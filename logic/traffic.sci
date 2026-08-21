function GAME = apply_turn_scenario(GAME)
    GAME.read_ratio = 0.70;
    GAME.static_ratio = 0.25;
    GAME.scenario_name = 'Baseline traffic';

    if modulo(GAME.turn, 12) == 4 then
        GAME.read_ratio = 0.90;
        GAME.static_ratio = 0.10;
        GAME.scenario_name = 'Read-heavy workload';
    elseif modulo(GAME.turn, 12) == 7 then
        GAME.read_ratio = 0.70;
        GAME.static_ratio = 0.60;
        GAME.scenario_name = 'Static-content surge';
    elseif modulo(GAME.turn, 12) == 10 then
        GAME.read_ratio = 0.25;
        GAME.static_ratio = 0.10;
        GAME.scenario_name = 'Write-heavy workload';
    end
endfunction

// Returns updated GAME, [new_rps, spike_occurred]. Scenarios are deterministic;
// organic traffic and spike timing retain some replay variety.
function [GAME, new_rps, spike_occurred] = get_next_rps(GAME)
    GAME = apply_turn_scenario(GAME);
    growth = 1 + (0.05 + rand()*0.10);   // 5%-15% organic growth per turn
    base_rps = GAME.rps * growth;

    spike_chance = 0.20;                 // 20% chance of a spike event each turn
    spike_occurred = %f;

    if rand() < spike_chance then
        spike_factor = 3 + rand()*3;     // 3x to 6x traffic
        new_rps = base_rps * spike_factor;
        spike_occurred = %t;
    else
        new_rps = base_rps;
    end

    new_rps = round(new_rps);
endfunction
