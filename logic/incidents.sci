function incident = build_incident(GAME)
    t = GAME.telemetry;
    incident = struct('title', 'Scaling review', 'evidence', 'No component exceeded its operating limit.', ...
        'lesson', 'Your architecture kept traffic within available capacity.', ...
        'url', 'https://docs.aws.amazon.com/elasticloadbalancing/latest/userguide/how-elastic-load-balancing-works.html');

    if ~GAME.has_lb & GAME.servers > 1 & t.app_utilization(1) > 1 then
        incident.title = 'App-server traffic concentration';
        incident.evidence = 'app-server-1 reached ' + string(round(t.app_utilization(1) * 100)) + '% while other app servers received no requests.';
        incident.lesson = 'Compute only adds usable capacity when requests are distributed to it.';
        incident.url = 'https://docs.aws.amazon.com/elasticloadbalancing/latest/userguide/how-elastic-load-balancing-works.html';
    elseif ~GAME.has_cdn & GAME.static_ratio >= 0.60 & max(t.app_utilization) > 1 then
        incident.title = 'Static-content traffic reached the app tier';
        incident.evidence = 'A static-content surge sent all requests through the application servers.';
        incident.lesson = 'A CDN can serve cacheable edge content before it consumes application capacity.';
        incident.url = 'https://www.cloudflare.com/learning/cdn/what-is-a-cdn/';
    elseif ~GAME.has_cache & GAME.read_ratio >= 0.85 & t.primary_utilization > 1 then
        incident.title = 'Repeated reads reached the primary database';
        incident.evidence = 'Read-heavy traffic drove the primary database to ' + string(round(t.primary_utilization * 100)) + '% utilization.';
        incident.lesson = 'Caching repeated reads can reduce database work and request latency.';
        incident.url = 'https://redis.io/docs/latest/develop/clients/client-side-caching/';
    elseif t.primary_utilization > 1 & GAME.db_replicas == 0 then
        incident.title = 'Primary database saturation';
        incident.evidence = 'Primary database utilization reached ' + string(round(t.primary_utilization * 100)) + '% with all reads served by one database.';
        incident.lesson = 'Read-heavy systems can relieve a primary database by routing reads to replicas.';
        incident.url = 'https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ReadRepl.html';
    elseif t.primary_utilization > 1 & GAME.db_replicas > 0 & ~GAME.sharded then
        incident.title = 'Database write bottleneck';
        incident.evidence = 'The primary database remained overloaded even with read replicas present.';
        incident.lesson = 'Read replicas help reads; sustained write pressure needs data partitioning or another write-scaling design.';
        incident.url = 'https://www.mongodb.com/docs/manual/sharding';
    elseif t.worst_utilization > 1 then
        incident.title = 'Capacity exceeded';
        incident.evidence = t.highest_pressure + ' reached ' + string(round(t.worst_utilization * 100)) + '% utilization.';
        incident.lesson = 'A system fails at its most constrained component, not at its average capacity.';
    end
endfunction
