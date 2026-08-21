global GAME

function init_game_state()
    global GAME
    GAME = struct();
    GAME.servers = 1;
    GAME.has_cache = %f;
    GAME.has_lb = %f;
    GAME.db_replicas = 0;
    GAME.has_cdn = %f;
    GAME.sharded = %f;
    GAME.budget = 3000;
    GAME.health = 100;
    GAME.rps = 200;
    GAME.capacity = 500;
    GAME.latency = 50;
    GAME.error_rate = 0;
    GAME.read_ratio = 0.70;
    GAME.static_ratio = 0.25;
    GAME.scenario_name = 'Baseline traffic';
    GAME.incident = struct();
    GAME.turn = 1;
    GAME.max_turns = 15;
    GAME.peak_rps = 200;
    GAME.key_mistake = 'None yet — smooth scaling!';
    GAME.log = ['Turn 1: System initialized. 1 App Server online.'];
    GAME = refresh_telemetry(GAME);
endfunction

function reset_game_state()
    init_game_state();
endfunction
