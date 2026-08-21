function GAME = do_add_server(GAME)
    cost = 500; t = string(GAME.turn);
    if GAME.budget >= cost then
        GAME.budget = GAME.budget - cost;
        GAME.servers = GAME.servers + 1;
        GAME.log = [GAME.log; 'Turn ' + t + ': Added 1 App Server.'];
    else
        GAME.log = [GAME.log; 'Turn ' + t + ': Not enough budget for App Server ($500).'];
    end
endfunction

function GAME = do_add_cache(GAME)
    cost = 800; t = string(GAME.turn);
    if GAME.has_cache then
        GAME.log = [GAME.log; 'Turn ' + t + ': Cache already enabled.'];
    elseif GAME.budget >= cost then
        GAME.budget = GAME.budget - cost;
        GAME.has_cache = %t;
        GAME.log = [GAME.log; 'Turn ' + t + ': Cache layer enabled.'];
    else
        GAME.log = [GAME.log; 'Turn ' + t + ': Not enough budget for Cache ($800).'];
    end
endfunction

function GAME = do_add_replica(GAME)
    cost = 1000; t = string(GAME.turn);
    if GAME.budget >= cost then
        GAME.budget = GAME.budget - cost;
        GAME.db_replicas = GAME.db_replicas + 1;
        GAME.log = [GAME.log; 'Turn ' + t + ': Added 1 DB Replica.'];
    else
        GAME.log = [GAME.log; 'Turn ' + t + ': Not enough budget for DB Replica ($1000).'];
    end
endfunction

function GAME = do_add_lb(GAME)
    cost = 600; t = string(GAME.turn);
    if GAME.has_lb then
        GAME.log = [GAME.log; 'Turn ' + t + ': Load Balancer already enabled.'];
    elseif GAME.budget >= cost then
        GAME.budget = GAME.budget - cost;
        GAME.has_lb = %t;
        GAME.log = [GAME.log; 'Turn ' + t + ': Load Balancer enabled.'];
    else
        GAME.log = [GAME.log; 'Turn ' + t + ': Not enough budget for Load Balancer ($600).'];
    end
endfunction

function GAME = do_add_cdn(GAME)
    cost = 700; t = string(GAME.turn);
    if GAME.has_cdn then
        GAME.log = [GAME.log; 'Turn ' + t + ': CDN already enabled.'];
    elseif GAME.budget >= cost then
        GAME.budget = GAME.budget - cost;
        GAME.has_cdn = %t;
        GAME.log = [GAME.log; 'Turn ' + t + ': CDN enabled.'];
    else
        GAME.log = [GAME.log; 'Turn ' + t + ': Not enough budget for CDN ($700).'];
    end
endfunction

function GAME = do_shard_db(GAME)
    cost = 1500; t = string(GAME.turn);
    if GAME.sharded then
        GAME.log = [GAME.log; 'Turn ' + t + ': Database already sharded.'];
    elseif GAME.db_replicas < 1 then
        GAME.log = [GAME.log; 'Turn ' + t + ': Sharding unavailable: replica prerequisite is not met.'];
    elseif GAME.budget >= cost then
        GAME.budget = GAME.budget - cost;
        GAME.sharded = %t;
        GAME.log = [GAME.log; 'Turn ' + t + ': Database sharded.'];
    else
        GAME.log = [GAME.log; 'Turn ' + t + ': Not enough budget for Sharding ($1500).'];
    end
endfunction
