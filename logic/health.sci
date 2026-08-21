function GAME = update_health(GAME)
    GAME = refresh_telemetry(GAME);
    ratio = GAME.telemetry.worst_utilization;

    if ratio <= 1 then
        GAME.latency = 50 + ratio*100;
        GAME.error_rate = 0;
        GAME.health = min(100, GAME.health + 5);   // slow recovery when healthy
    else
        overload = ratio - 1;
        GAME.latency = 50 + ratio*300;
        GAME.error_rate = min(100, overload*100);
        GAME.health = max(0, GAME.health - GAME.error_rate*0.3);
    end
endfunction
