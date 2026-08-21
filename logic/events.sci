// Returns updated GAME and a column vector of new log message strings
function [GAME, msgs] = trigger_events(GAME, spike_occurred)
    msgs = [];
    t = string(GAME.turn);

    if spike_occurred then
        pool = ['A blog post about your app went viral.'; ..
                'A major news outlet linked to your site.'; ..
                'A marketing campaign drove a surge of new users.'; ..
                'Your app got featured on a popular app store list.'];
        idx = 1 + floor(rand()*size(pool,1));
        msgs = [msgs; 'Turn ' + t + ': ' + pool(idx) + ' Traffic jumped to ' + string(GAME.rps) + ' RPS!'];
    else
        msgs = [msgs; 'Turn ' + t + ': Traffic at ' + string(GAME.rps) + ' RPS.'];
    end

    if GAME.scenario_name <> 'Baseline traffic' then
        msgs = [msgs; 'Workload profile: ' + GAME.scenario_name + '.'];
    end

    pressure = GAME.telemetry.worst_utilization;
    component = GAME.telemetry.highest_pressure;
    if pressure > 1 then
        msgs = [msgs; 'ALERT: ' + component + ' saturation at ' + string(round(pressure * 100)) + '%.'];
        if GAME.key_mistake == 'None yet — smooth scaling!' then
            GAME.key_mistake = 'A component exceeded capacity around Turn ' + t + '.';
        end
    elseif pressure > 0.85 then
        msgs = [msgs; 'NOTICE: ' + component + ' is operating at ' + string(round(pressure * 100)) + '%.'];
    elseif pressure > 0.70 then
        msgs = [msgs; 'OBSERVATION: ' + component + ' utilization is rising.'];
    end

    if GAME.health <= 30 & GAME.health > 0 then
        msgs = [msgs; 'CRITICAL: System health is low. Users are experiencing failures.'];
    end
endfunction
