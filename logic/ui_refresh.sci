function refresh_metrics()
    global GAME GAME_FIG

    h = findobj(GAME_FIG, 'tag', 'lbl_rps');
    h.string = 'Current RPS:           ' + string(round(GAME.rps));

    h = findobj(GAME_FIG, 'tag', 'lbl_capacity');
    h.string = 'Capacity:                ' + string(round(GAME.capacity));

    h = findobj(GAME_FIG, 'tag', 'lbl_latency');
    h.string = 'Request Latency:     ' + string(round(GAME.latency)) + ' ms';

    h = findobj(GAME_FIG, 'tag', 'lbl_errors');
    h.string = 'Errors:                     ' + string(round(GAME.error_rate)) + ' %';

    h = findobj(GAME_FIG, 'tag', 'bar_health');
    h.string = 'System Health:       ' + string(round(GAME.health)) + ' %';
    if GAME.health <= 30 then
        h.foregroundcolor = [0.95, 0.40, 0.40];
    elseif GAME.health <= 60 then
        h.foregroundcolor = [0.88, 0.68, 0.40];
    else
        h.foregroundcolor = [0.55, 0.85, 0.45];
    end

    h = findobj(GAME_FIG, 'tag', 'lbl_budget');
    h.string = 'Budget:                   $' + string(round(GAME.budget));

    h = findobj(GAME_FIG, 'tag', 'lbl_turn');
    h.string = 'Turn:                       ' + string(GAME.turn);

    h = findobj(GAME_FIG, 'tag', 'lbl_pressure');
    h.string = 'Highest pressure:    ' + GAME.telemetry.highest_pressure + ' (' + string(round(GAME.telemetry.worst_utilization * 100)) + '%)';
    if GAME.telemetry.worst_utilization > 1 then
        h.foregroundcolor = [0.95, 0.40, 0.40];
    elseif GAME.telemetry.worst_utilization > 0.70 then
        h.foregroundcolor = [0.88, 0.68, 0.40];
    else
        h.foregroundcolor = [0.55, 0.85, 0.45];
    end
endfunction

function refresh_log()
    global GAME GAME_FIG
    h = findobj(GAME_FIG, 'tag', 'txt_log');
    h.string = GAME.log;
    h.value = size(GAME.log, 1);   // auto-scroll to latest line
endfunction

// Draw a labelled component box centered at (x, y) on the architecture axes.
function arch_draw_box(x, y, w, h, title, subtitle, fill_color, border_color, text_color)
    xrect(x - w / 2, y + h / 2, w, h);
    h_box = gce();
    h_box.background = fill_color;
    h_box.foreground = border_color;
    h_box.thickness = 2;

    xstring(x - w / 2 + 1.5, y + 2, title);
    h_title = gce();
    h_title.font_foreground = text_color;
    h_title.font_size = 2;

    if subtitle <> '' then
        xstring(x - w / 2 + 1.5, y - 4, subtitle);
        h_subtitle = gce();
        h_subtitle.font_foreground = text_color;
        h_subtitle.font_size = 1;
    end
endfunction

function color_index = arch_status_color(status, blue_color, green_color, amber_color, red_color, idle_color)
    color_index = blue_color;
    if status == 'healthy' then
        color_index = green_color;
    elseif status == 'warning' then
        color_index = amber_color;
    elseif status == 'critical' | status == 'overloaded' then
        color_index = red_color;
    elseif status == 'idle' then
        color_index = idle_color;
    end
endfunction

// Draw a solid request-flow arrow with a filled arrowhead. Idle routes are dashed.
function arch_draw_arrow(x1, y1, x2, y2, line_color, label, dashed)
    xpoly([x1, x2], [y1, y2], 'lines');
    h_line = gce();
    h_line.foreground = line_color;
    h_line.thickness = 2;
    if dashed then h_line.line_style = 2; end

    dx = x2 - x1;
    dy = y2 - y1;
    length = max(sqrt(dx * dx + dy * dy), 0.01);
    ux = dx / length;
    uy = dy / length;
    px = -uy;
    py = ux;
    head = 2.4;
    wing = 1.4;
    xfpoly([x2, x2 - head * ux + wing * px, x2 - head * ux - wing * px], ...
           [y2, y2 - head * uy + wing * py, y2 - head * uy - wing * py]);
    h_head = gce();
    h_head.foreground = line_color;
    h_head.background = line_color;

    if label <> '' then
        xstring((x1 + x2) / 2 - 2, (y1 + y2) / 2 + 2, label);
        h_label = gce();
        h_label.font_foreground = line_color;
        h_label.font_size = 1;
    end
endfunction

function refresh_architecture()
    global GAME ARCH_AX

    if isempty(ARCH_AX) then
        return;
    end

    // All drawing is recreated from GAME, avoiding stale topology after upgrades.
    try
        sca(ARCH_AX);
        delete(ARCH_AX.children);
    catch
        return;
    end

    ARCH_AX.data_bounds = [0, 0; 100, 100];
    ARCH_AX.axes_visible = 'off';
    ARCH_AX.box = 'off';

    panel_color = addcolor([0.15, 0.17, 0.20]);
    component_color = addcolor([0.20, 0.25, 0.31]);
    blue_color = addcolor([0.35, 0.65, 0.90]);
    white_color = addcolor([0.88, 0.88, 0.88]);
    green_color = addcolor([0.55, 0.85, 0.45]);
    amber_color = addcolor([0.88, 0.68, 0.40]);
    red_color = addcolor([0.95, 0.40, 0.40]);
    idle_color = addcolor([0.42, 0.45, 0.48]);
    t = GAME.telemetry;
    status_color = arch_status_color(t.highest_status, blue_color, green_color, amber_color, red_color, idle_color);

    drawlater();

    xstring(4, 95, 'LIVE REQUEST FLOW');
    h_header = gce();
    h_header.font_foreground = blue_color;
    h_header.font_size = 2;

    xstring(4, 89, string(round(GAME.rps)) + ' RPS incoming  |  ' + GAME.scenario_name);
    h_rps = gce();
    h_rps.font_foreground = white_color;
    h_rps.font_size = 1;

    xstring(66, 95, convstr(t.highest_status, 'u') + '  (' + string(round(t.worst_utilization * 100)) + '%)');
    h_status = gce();
    h_status.font_foreground = status_color;
    h_status.font_size = 1;

    user_x = 8;
    user_y = 58;
    route_x = user_x + 6;
    route_y = user_y;
    arch_draw_box(user_x, user_y, 12, 16, 'Users', string(round(t.edge_rps)) + ' RPS', component_color, blue_color, white_color);

    if GAME.has_cdn then
        cdn_x = 21;
        cdn_status = component_status(t.edge_utilization, t.edge_rps * t.cdn_offload);
        cdn_color = arch_status_color(cdn_status, blue_color, green_color, amber_color, red_color, idle_color);
        arch_draw_arrow(route_x, route_y, cdn_x - 6, user_y, cdn_color, '', %f);
        arch_draw_box(cdn_x, user_y, 12, 16, 'CDN', 'Offload ' + string(round(t.cdn_offload * 100)) + '%', component_color, cdn_color, white_color);
        route_x = cdn_x + 6;
    end

    if GAME.has_lb then
        lb_x = 34;
        lb_status = component_status(t.lb_utilization, t.app_rps);
        lb_color = arch_status_color(lb_status, blue_color, green_color, amber_color, red_color, idle_color);
        arch_draw_arrow(route_x, route_y, lb_x - 6, user_y, lb_color, string(round(t.app_rps)) + ' RPS', %f);
        arch_draw_box(lb_x, user_y, 12, 16, 'Load Balancer', string(round(t.lb_utilization * 100)) + '% routing', component_color, lb_color, white_color);
        route_x = lb_x + 6;
    end

    // Render every server. Without a load balancer, only server 1 has an incoming route.
    app_x = 54;
    app_y = zeros(GAME.servers, 1);
    app_node_x = zeros(GAME.servers, 1);
    for i = 1:GAME.servers
        // Six rows keep the largest affordable server fleet within two columns.
        column = floor((i - 1) / 6);
        row = modulo(i - 1, 6);
        app_node_x(i) = app_x + column * 11;
        app_y(i) = 82 - row * 12;
        app_status = component_status(t.app_utilization(i), t.app_rps_each(i));
        app_color = arch_status_color(app_status, blue_color, green_color, amber_color, red_color, idle_color);
        app_subtitle = string(round(t.app_rps_each(i))) + ' RPS | ' + string(round(t.app_utilization(i) * 100)) + '%';
        arch_draw_box(app_node_x(i), app_y(i), 11, 11, 'App ' + string(i), app_subtitle, component_color, app_color, white_color);
        if GAME.has_lb | i == 1 then
            arrow_label = '';
            if GAME.has_lb then arrow_label = string(round(t.app_rps_each(i))); end
            arch_draw_arrow(route_x, route_y, app_node_x(i) - 5.5, app_y(i), app_color, arrow_label, %f);
        end
    end

    cache_x = 78;
    cache_y = 58;
    db_x = 92;
    db_y = 58;
    if GAME.has_cache then
        cache_status = component_status(t.cache_utilization, t.cache_rps);
        cache_color = arch_status_color(cache_status, blue_color, green_color, amber_color, red_color, idle_color);
        arch_draw_box(cache_x, cache_y, 12, 16, 'Cache', 'Hit ' + string(round(t.cache_hit_rate * 100)) + '%', component_color, cache_color, white_color);
        for i = 1:GAME.servers
            if t.app_rps_each(i) > 0 then
                arch_draw_arrow(app_node_x(i) + 5.5, app_y(i), cache_x - 6, cache_y, cache_color, '', %f);
            end
        end
        arch_draw_arrow(cache_x + 6, cache_y, db_x - 6, db_y, arch_status_color(component_status(t.primary_utilization, t.primary_rps), blue_color, green_color, amber_color, red_color, idle_color), string(round(t.primary_rps)) + ' RPS', %f);
    else
        for i = 1:GAME.servers
            if t.app_rps_each(i) > 0 then
                db_link_color = arch_status_color(component_status(t.primary_utilization, t.primary_rps), blue_color, green_color, amber_color, red_color, idle_color);
                arch_draw_arrow(app_node_x(i) + 5.5, app_y(i), db_x - 6, db_y, db_link_color, '', %f);
            end
        end
    end

    db_status = component_status(t.primary_utilization, t.primary_rps);
    db_color = arch_status_color(db_status, blue_color, green_color, amber_color, red_color, idle_color);
    db_title = 'Primary DB';
    db_subtitle = string(round(t.primary_rps)) + ' RPS | ' + string(round(t.primary_utilization * 100)) + '%';
    if GAME.sharded then db_title = 'Sharded DB'; db_subtitle = '2 partitions | ' + string(round(t.primary_utilization * 100)) + '%'; end
    arch_draw_box(db_x, db_y, 12, 16, db_title, db_subtitle, component_color, db_color, white_color);

    for i = 1:GAME.db_replicas
        replica_x = 81 + modulo(i - 1, 2) * 13;
        replica_y = 26 - floor((i - 1) / 2) * 13;
        replica_status = component_status(t.replica_utilization(i), t.replica_rps_each(i));
        replica_color = arch_status_color(replica_status, blue_color, green_color, amber_color, red_color, idle_color);
        arch_draw_arrow(db_x, db_y - 8, replica_x, replica_y + 5, replica_color, '', %f);
        arch_draw_box(replica_x, replica_y, 12, 10, 'Replica ' + string(i), string(round(t.replica_utilization(i) * 100)) + '% read', component_color, replica_color, white_color);
    end

    xstring(4, 10, 'Capacity: ' + string(round(GAME.capacity)) + ' RPS');
    h_capacity = gce();
    h_capacity.font_foreground = white_color;
    h_capacity.font_size = 1;

    xstring(44, 10, get_observation(GAME));
    h_health = gce();
    h_health.font_foreground = status_color;
    h_health.font_size = 1;

    drawnow();
endfunction

function populate_end_screen()
    global GAME END_FIG

    h = findobj(END_FIG, 'tag', 'lbl_result');
    if GAME.health <= 0 then
        h.string = 'SYSTEM DOWN';
        h.foregroundcolor = [0.95, 0.40, 0.40];
    else
        h.string = 'YOU SCALED SUCCESSFULLY';
        h.foregroundcolor = [0.55, 0.85, 0.45];
    end

    h = findobj(END_FIG, 'tag', 'lbl_stat1_v');
    h.string = string(GAME.turn - 1);

    h = findobj(END_FIG, 'tag', 'lbl_stat2_v');
    h.string = string(round(GAME.peak_rps));

    arch_desc = '';
    if GAME.has_lb then arch_desc = arch_desc + 'Load Balancer + '; end
    arch_desc = arch_desc + string(GAME.servers) + ' App Server(s)';
    if GAME.has_cache then arch_desc = arch_desc + ' + Cache'; end
    if GAME.db_replicas > 0 then arch_desc = arch_desc + ' + ' + string(GAME.db_replicas) + ' DB Replica(s)'; end
    if GAME.has_cdn then arch_desc = arch_desc + ' + CDN'; end
    if GAME.sharded then arch_desc = arch_desc + ' + Sharded DB'; end

    h = findobj(END_FIG, 'tag', 'lbl_stat3_v');
    h.string = arch_desc;

    h = findobj(END_FIG, 'tag', 'lbl_stat4_v');
    h.string = GAME.key_mistake;

    h = findobj(END_FIG, 'tag', 'lbl_incident_v');
    h.string = GAME.incident.title;

    h = findobj(END_FIG, 'tag', 'lbl_evidence_v');
    h.string = GAME.incident.evidence;

    h = findobj(END_FIG, 'tag', 'lbl_lesson_v');
    h.string = GAME.incident.lesson;

    h = findobj(END_FIG, 'tag', 'lbl_resource_url');
    h.string = GAME.incident.url;
endfunction
