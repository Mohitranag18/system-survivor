function build_game_screen()
    global GAME_FIG ARCH_AX

    bg_color = [0.12, 0.13, 0.16];
    panel_bg = [0.15, 0.17, 0.20];
    text_blue = [0.35, 0.65, 0.90];
    text_white = [0.85, 0.85, 0.85];
    btn_blue = [0.25, 0.45, 0.75];

    f = figure('figure_position', [12, 52], 'figure_size', [1200, 750], 'auto_resize', 'on', ...
        'background', -2, 'figure_name', 'System Survivor - Game', ...
        'dockable', 'off', 'infobar_visible', 'off', 'toolbar_visible', 'off', ...
        'menubar_visible', 'off', 'default_axes', 'on', 'visible', 'off');

    f.background = addcolor(bg_color);

    handles.dummy = 0;

    // A. ARCHITECTURE
    handles.lbl_title_a = uicontrol(f, 'unit', 'normalized', 'Position', [0.02, 0.92, 0.54, 0.04], ...
        'BackgroundColor', bg_color, 'ForegroundColor', text_blue, 'FontWeight', 'bold', ...
        'FontSize', 14, 'HorizontalAlignment', 'left', 'Style', 'text', 'String', 'A. ARCHITECTURE');

    handles.ax_architecture = newaxes();
    handles.ax_architecture.margins = [0, 0, 0, 0];
    handles.ax_architecture.axes_bounds = [0.02, 0.10, 0.54, 0.45];
    handles.ax_architecture.background = addcolor(panel_bg);
    handles.ax_architecture.data_bounds = [0, 0; 100, 100];
    handles.ax_architecture.axes_visible = 'off';
    handles.ax_architecture.box = 'off';
    handles.ax_architecture.auto_clear = 'off';
    ARCH_AX = handles.ax_architecture;

    // B. METRICS
    handles.lbl_title_b = uicontrol(f, 'unit', 'normalized', 'Position', [0.58, 0.92, 0.40, 0.04], ...
        'BackgroundColor', bg_color, 'ForegroundColor', text_blue, 'FontWeight', 'bold', ...
        'FontSize', 14, 'HorizontalAlignment', 'left', 'Style', 'text', 'String', 'B. METRICS');

    handles.lbl_rps = uicontrol(f, 'unit', 'normalized', 'Position', [0.58, 0.84, 0.40, 0.04], ...
        'BackgroundColor', bg_color, 'ForegroundColor', text_white, 'FontSize', 14, ...
        'HorizontalAlignment', 'left', 'Style', 'text', 'String', 'Current RPS:', 'Tag', 'lbl_rps');

    handles.lbl_capacity = uicontrol(f, 'unit', 'normalized', 'Position', [0.58, 0.79, 0.40, 0.04], ...
        'BackgroundColor', bg_color, 'ForegroundColor', text_white, 'FontSize', 14, ...
        'HorizontalAlignment', 'left', 'Style', 'text', 'String', 'Capacity:', 'Tag', 'lbl_capacity');

    handles.lbl_latency = uicontrol(f, 'unit', 'normalized', 'Position', [0.58, 0.74, 0.40, 0.04], ...
        'BackgroundColor', bg_color, 'ForegroundColor', text_white, 'FontSize', 14, ...
        'HorizontalAlignment', 'left', 'Style', 'text', 'String', 'Latency:', 'Tag', 'lbl_latency');

    handles.lbl_errors = uicontrol(f, 'unit', 'normalized', 'Position', [0.58, 0.69, 0.40, 0.04], ...
        'BackgroundColor', bg_color, 'ForegroundColor', text_white, 'FontSize', 14, ...
        'HorizontalAlignment', 'left', 'Style', 'text', 'String', 'Errors:', 'Tag', 'lbl_errors');

    handles.bar_health = uicontrol(f, 'unit', 'normalized', 'Position', [0.58, 0.64, 0.40, 0.04], ...
        'BackgroundColor', bg_color, 'ForegroundColor', text_white, 'FontSize', 14, ...
        'HorizontalAlignment', 'left', 'Style', 'text', 'String', 'System Health:', 'Tag', 'bar_health');

    handles.lbl_budget = uicontrol(f, 'unit', 'normalized', 'Position', [0.58, 0.59, 0.40, 0.04], ...
        'BackgroundColor', bg_color, 'ForegroundColor', text_white, 'FontSize', 14, ...
        'HorizontalAlignment', 'left', 'Style', 'text', 'String', 'Budget:', 'Tag', 'lbl_budget');

    handles.lbl_turn = uicontrol(f, 'unit', 'normalized', 'Position', [0.58, 0.54, 0.40, 0.04], ...
        'BackgroundColor', bg_color, 'ForegroundColor', text_white, 'FontSize', 14, ...
        'HorizontalAlignment', 'left', 'Style', 'text', 'String', 'Turn:', 'Tag', 'lbl_turn');

    handles.lbl_pressure = uicontrol(f, 'unit', 'normalized', 'Position', [0.58, 0.49, 0.40, 0.04], ...
        'BackgroundColor', bg_color, 'ForegroundColor', text_white, 'FontSize', 12, ...
        'HorizontalAlignment', 'left', 'Style', 'text', 'String', 'Highest pressure:', 'Tag', 'lbl_pressure');

    // C. EVENT LOG
    handles.lbl_title_c = uicontrol(f, 'unit', 'normalized', 'Position', [0.02, 0.38, 0.54, 0.04], ...
        'BackgroundColor', bg_color, 'ForegroundColor', text_blue, 'FontWeight', 'bold', ...
        'FontSize', 14, 'HorizontalAlignment', 'left', 'Style', 'text', 'String', 'C. EVENT LOG');

    handles.txt_log = uicontrol(f, 'unit', 'normalized', 'Position', [0.02, 0.02, 0.54, 0.35], ...
        'BackgroundColor', panel_bg, 'ForegroundColor', text_white, 'FontSize', 12, ...
        'FontName', 'monospaced', 'HorizontalAlignment', 'left', 'Style', 'listbox', ...
        'String', 'Starting your application....', 'Tag', 'txt_log', 'Callback', 'txt_log_callback()');

    // D. ACTIONS
    handles.lbl_title_d = uicontrol(f, 'unit', 'normalized', 'Position', [0.58, 0.38, 0.40, 0.04], ...
        'BackgroundColor', bg_color, 'ForegroundColor', text_blue, 'FontWeight', 'bold', ...
        'FontSize', 14, 'HorizontalAlignment', 'left', 'Style', 'text', 'String', 'D. ACTIONS');

    btn_h = 0.07;
    row_3 = 0.28;
    row_2 = 0.19;
    row_1 = 0.10;

    handles.btn_add_server = uicontrol(f, 'unit', 'normalized', 'Position', [0.58, row_3, 0.19, btn_h], ...
        'BackgroundColor', panel_bg, 'ForegroundColor', text_white, 'FontSize', 12, ...
        'Style', 'pushbutton', 'String', 'Add App Server ($500)', 'Tag', 'btn_add_server', 'Callback', 'btn_add_server_callback()');

    handles.btn_add_cache = uicontrol(f, 'unit', 'normalized', 'Position', [0.79, row_3, 0.19, btn_h], ...
        'BackgroundColor', panel_bg, 'ForegroundColor', text_white, 'FontSize', 12, ...
        'Style', 'pushbutton', 'String', 'Add Cache ($800)', 'Tag', 'btn_add_cache', 'Callback', 'btn_add_cache_callback()');

    handles.btn_add_replica = uicontrol(f, 'unit', 'normalized', 'Position', [0.58, row_2, 0.19, btn_h], ...
        'BackgroundColor', panel_bg, 'ForegroundColor', text_white, 'FontSize', 12, ...
        'Style', 'pushbutton', 'String', 'Add DB Replica ($1000)', 'Tag', 'btn_add_replica', 'Callback', 'btn_add_replica_callback()');

    handles.btn_add_lb = uicontrol(f, 'unit', 'normalized', 'Position', [0.79, row_2, 0.19, btn_h], ...
        'BackgroundColor', panel_bg, 'ForegroundColor', text_white, 'FontSize', 12, ...
        'Style', 'pushbutton', 'String', 'Enable Load Balancer ($600)', 'Tag', 'btn_add_lb', 'Callback', 'btn_add_lb_callback()');

    handles.btn_add_cdn = uicontrol(f, 'unit', 'normalized', 'Position', [0.58, row_1, 0.19, btn_h], ...
        'BackgroundColor', panel_bg, 'ForegroundColor', text_white, 'FontSize', 12, ...
        'Style', 'pushbutton', 'String', 'Add CDN ($700)', 'Tag', 'btn_add_cdn', 'Callback', 'btn_add_cdn_callback()');

    handles.btn_shard_db = uicontrol(f, 'unit', 'normalized', 'Position', [0.79, row_1, 0.19, btn_h], ...
        'BackgroundColor', panel_bg, 'ForegroundColor', text_white, 'FontSize', 12, ...
        'Style', 'pushbutton', 'String', 'Shard Database ($1500)', 'Tag', 'btn_shard_db', 'Callback', 'btn_shard_db_callback()');

    handles.btn_next_turn = uicontrol(f, 'unit', 'normalized', 'Position', [0.58, 0.02, 0.40, 0.06], ...
        'BackgroundColor', btn_blue, 'ForegroundColor', [1, 1, 1], 'FontSize', 14, 'FontWeight', 'bold', ...
        'Style', 'pushbutton', 'String', 'Next Turn', 'Tag', 'btn_next_turn', 'Callback', 'btn_next_turn_callback()');

    GAME_FIG = f;
    f.visible = "on";
endfunction

function txt_log_callback()
endfunction

function btn_add_server_callback()
    global GAME
    GAME = do_add_server(GAME);
    GAME = refresh_telemetry(GAME);
    refresh_metrics();
    refresh_log();
    refresh_architecture();
endfunction

function btn_add_cache_callback()
    global GAME
    GAME = do_add_cache(GAME);
    GAME = refresh_telemetry(GAME);
    refresh_metrics();
    refresh_log();
    refresh_architecture();
endfunction

function btn_add_replica_callback()
    global GAME
    GAME = do_add_replica(GAME);
    GAME = refresh_telemetry(GAME);
    refresh_metrics();
    refresh_log();
    refresh_architecture();
endfunction

function btn_add_lb_callback()
    global GAME
    GAME = do_add_lb(GAME);
    GAME = refresh_telemetry(GAME);
    refresh_metrics();
    refresh_log();
    refresh_architecture();
endfunction

function btn_add_cdn_callback()
    global GAME
    GAME = do_add_cdn(GAME);
    GAME = refresh_telemetry(GAME);
    refresh_metrics();
    refresh_log();
    refresh_architecture();
endfunction

function btn_shard_db_callback()
    global GAME
    GAME = do_shard_db(GAME);
    GAME = refresh_telemetry(GAME);
    refresh_metrics();
    refresh_log();
    refresh_architecture();
endfunction

function btn_next_turn_callback()
    global GAME

    [GAME, new_rps, spike_occurred] = get_next_rps(GAME);
    GAME.rps = new_rps;
    if GAME.rps > GAME.peak_rps then
        GAME.peak_rps = GAME.rps;
    end

    GAME = update_health(GAME);
    GAME.budget = GAME.budget + 150;

    [GAME, msgs] = trigger_events(GAME, spike_occurred);
    GAME.log = [GAME.log; msgs];

    GAME.turn = GAME.turn + 1;

    refresh_metrics();
    refresh_log();
    refresh_architecture();

    if GAME.health <= 0 then
        GAME.incident = build_incident(GAME);
        go_to_end();
    elseif GAME.turn > GAME.max_turns then
        GAME.incident = build_incident(GAME);
        go_to_end();
    end
endfunction
