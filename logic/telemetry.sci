function label = component_status(utilization, rps)
    if rps <= 0 then
        label = 'idle';
    elseif utilization > 1 then
        label = 'overloaded';
    elseif utilization > 0.85 then
        label = 'critical';
    elseif utilization > 0.70 then
        label = 'warning';
    else
        label = 'healthy';
    end
endfunction

function GAME = refresh_telemetry(GAME)
    // Fixed, intentionally simple model constants for the learning simulation.
    app_capacity = 500;
    primary_db_capacity = 500;
    replica_capacity = 300;
    cache_capacity = 2500;
    edge_capacity = 5000;

    cdn_offload = 0;
    if GAME.has_cdn then
        cdn_offload = GAME.static_ratio;
    end
    app_rps = GAME.rps * (1 - cdn_offload);

    app_rps_each = zeros(GAME.servers, 1);
    if GAME.has_lb then
        app_rps_each = ones(GAME.servers, 1) * app_rps / GAME.servers;
    else
        // Extra servers exist, but have no path for traffic without a load balancer.
        app_rps_each(1) = app_rps;
    end
    app_utilization = app_rps_each / app_capacity;

    cache_hit_rate = 0;
    if GAME.has_cache then
        cache_hit_rate = 0.35;
    end
    cache_rps = app_rps;
    cache_utilization = 0;
    if GAME.has_cache then
        cache_utilization = cache_rps / cache_capacity;
    end

    read_rps = app_rps * GAME.read_ratio * (1 - cache_hit_rate);
    write_rps = app_rps * (1 - GAME.read_ratio);
    primary_read_rps = read_rps;
    replica_rps_each = zeros(GAME.db_replicas, 1);
    if GAME.db_replicas > 0 then
        primary_read_rps = read_rps / (GAME.db_replicas + 1);
        replica_rps_each = ones(GAME.db_replicas, 1) * primary_read_rps;
    end

    shard_factor = 1;
    if GAME.sharded then
        shard_factor = 2;
    end
    primary_rps = primary_read_rps + write_rps;
    primary_utilization = primary_rps / (primary_db_capacity * shard_factor);
    replica_utilization = replica_rps_each / (replica_capacity * shard_factor);

    edge_utilization = GAME.rps / edge_capacity;
    lb_utilization = 0;
    if GAME.has_lb then
        lb_utilization = app_rps / edge_capacity;
    end

    all_utilizations = [app_utilization; primary_utilization; replica_utilization];
    all_names = [];
    for i = 1:GAME.servers
        all_names = [all_names; 'app-server-' + string(i)];
    end
    all_names = [all_names; 'primary-database'];
    for i = 1:GAME.db_replicas
        all_names = [all_names; 'db-replica-' + string(i)];
    end
    if GAME.has_cache then
        all_utilizations = [all_utilizations; cache_utilization];
        all_names = [all_names; 'cache'];
    end
    if GAME.has_lb then
        all_utilizations = [all_utilizations; lb_utilization];
        all_names = [all_names; 'load-balancer'];
    end
    if GAME.has_cdn then
        all_utilizations = [all_utilizations; edge_utilization];
        all_names = [all_names; 'cdn'];
    end

    [worst_utilization, worst_index] = max(all_utilizations);
    highest_pressure = all_names(worst_index);

    app_external_capacity = app_capacity;
    if GAME.has_lb then
        app_external_capacity = app_capacity * GAME.servers;
    end
    app_external_capacity = app_external_capacity / (1 - cdn_offload);

    db_capacity = primary_db_capacity * shard_factor + GAME.db_replicas * replica_capacity * shard_factor;
    db_request_factor = GAME.read_ratio * (1 - cache_hit_rate) + (1 - GAME.read_ratio);
    db_external_capacity = db_capacity / max(db_request_factor * (1 - cdn_offload), 0.01);

    GAME.capacity = round(min(app_external_capacity, db_external_capacity));
    GAME.telemetry = struct( ...
        'edge_rps', GAME.rps, ...
        'cdn_offload', cdn_offload, ...
        'app_rps', app_rps, ...
        'app_rps_each', app_rps_each, ...
        'app_utilization', app_utilization, ...
        'cache_rps', cache_rps, ...
        'cache_hit_rate', cache_hit_rate, ...
        'cache_utilization', cache_utilization, ...
        'read_rps', read_rps, ...
        'write_rps', write_rps, ...
        'primary_rps', primary_rps, ...
        'primary_utilization', primary_utilization, ...
        'replica_rps_each', replica_rps_each, ...
        'replica_utilization', replica_utilization, ...
        'edge_utilization', edge_utilization, ...
        'lb_utilization', lb_utilization, ...
        'worst_utilization', worst_utilization, ...
        'highest_pressure', highest_pressure, ...
        'highest_status', component_status(worst_utilization, 1));
endfunction

function observation = get_observation(GAME)
    t = GAME.telemetry;
    if ~GAME.has_lb & GAME.servers > 1 & t.app_utilization(1) > 0.70 then
        observation = 'Request concentration detected on app-server-1.';
    elseif t.primary_utilization > 0.70 then
        observation = 'Primary database utilization is rising.';
    elseif GAME.has_cache & t.cache_utilization > 0.70 then
        observation = 'Cache pressure is increasing.';
    elseif t.worst_utilization > 0.70 then
        observation = 'The highest-pressure component is ' + t.highest_pressure + '.';
    else
        observation = 'Traffic is within current component limits.';
    end
endfunction
