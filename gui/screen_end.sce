function build_end_screen()
    global END_FIG

    f = figure('figure_position', [12, 52], 'figure_size', [1000, 650], 'auto_resize', 'on', ...
        'background', -2, 'figure_name', 'System Survivor - Result', ...
        'dockable', 'off', 'infobar_visible', 'off', 'toolbar_visible', 'off', ...
        'menubar_visible', 'off', 'default_axes', 'on', 'visible', 'off');


    // Define color palette for the dark theme
    bg_color = [0.12, 0.13, 0.16];       // Dark background
    panel_bg = [0.15, 0.17, 0.20];       // Slightly lighter dark for panels/buttons
    text_white = [0.85, 0.85, 0.85];     // Main text color
    text_red = [0.95, 0.40, 0.40];       // Error/Mistake red
    btn_blue = [0.25, 0.45, 0.75];       // Action button blue

    f.background = addcolor(bg_color);   // Add custom background color to figure map
    //////////
    handles.dummy = 0;

    // ==========================================
    // TITLE: SYSTEM DOWN
    // ==========================================
    handles.lbl_result = uicontrol(f, 'unit', 'normalized', 'Position', [0.20, 0.88, 0.60, 0.08], ...
        'BackgroundColor', bg_color, 'ForegroundColor', text_red, 'FontWeight', 'bold', ...
        'FontSize', 28, 'HorizontalAlignment', 'center', 'Style', 'text', 'String', 'SYSTEM DOWN', 'Tag', 'lbl_result');

    // ==========================================
    // SUMMARY PANEL
    // ==========================================
    // Background frame for the summary
    handles.bg_summary = uicontrol(f, 'unit', 'normalized', 'Position', [0.05, 0.55, 0.90, 0.28], ...
        'BackgroundColor', panel_bg, 'Style', 'frame');

    // Row 1: Turns Survived
    handles.lbl_stat1_k = uicontrol(f, 'unit', 'normalized', 'Position', [0.08, 0.76, 0.25, 0.05], ...
        'BackgroundColor', panel_bg, 'ForegroundColor', text_white, 'FontSize', 13, ...
        'HorizontalAlignment', 'left', 'Style', 'text', 'String', 'Turns Survived:');
    handles.lbl_stat1_v = uicontrol(f, 'unit', 'normalized', 'Position', [0.35, 0.76, 0.50, 0.05], ...
        'BackgroundColor', panel_bg, 'ForegroundColor', text_white, 'FontSize', 13, ...
        'HorizontalAlignment', 'left', 'Style', 'text', 'String', '12');

    // Row 2: Peak RPS Handled
    handles.lbl_stat2_k = uicontrol(f, 'unit', 'normalized', 'Position', [0.08, 0.69, 0.25, 0.05], ...
        'BackgroundColor', panel_bg, 'ForegroundColor', text_white, 'FontSize', 13, ...
        'HorizontalAlignment', 'left', 'Style', 'text', 'String', 'Peak RPS Handled:');
    handles.lbl_stat2_v = uicontrol(f, 'unit', 'normalized', 'Position', [0.35, 0.69, 0.50, 0.05], ...
        'BackgroundColor', panel_bg, 'ForegroundColor', text_white, 'FontSize', 13, ...
        'HorizontalAlignment', 'left', 'Style', 'text', 'String', '8,400');

    // Row 3: Final Architecture
    handles.lbl_stat3_k = uicontrol(f, 'unit', 'normalized', 'Position', [0.08, 0.62, 0.25, 0.05], ...
        'BackgroundColor', panel_bg, 'ForegroundColor', text_white, 'FontSize', 13, ...
        'HorizontalAlignment', 'left', 'Style', 'text', 'String', 'Final Architecture:');
    handles.lbl_stat3_v = uicontrol(f, 'unit', 'normalized', 'Position', [0.35, 0.62, 0.60, 0.05], ...
        'BackgroundColor', panel_bg, 'ForegroundColor', text_white, 'FontSize', 13, ...
        'HorizontalAlignment', 'left', 'Style', 'text', 'String', 'Load Balancer + 3 App Servers + Cache + DB Replica');

    // Row 4: Key Mistake
    handles.lbl_stat4_k = uicontrol(f, 'unit', 'normalized', 'Position', [0.08, 0.55, 0.25, 0.05], ...
        'BackgroundColor', panel_bg, 'ForegroundColor', text_red, 'FontSize', 13, ...
        'HorizontalAlignment', 'left', 'Style', 'text', 'String', 'Key Mistake:');
    handles.lbl_stat4_v = uicontrol(f, 'unit', 'normalized', 'Position', [0.35, 0.55, 0.60, 0.05], ...
        'BackgroundColor', panel_bg, 'ForegroundColor', text_white, 'FontSize', 13, ...
        'HorizontalAlignment', 'left', 'Style', 'text', 'String', 'No caching layer before Turn 5 spike');

    // Incident debrief: evidence first, then an optional external learning resource.
    handles.bg_debrief = uicontrol(f, 'unit', 'normalized', 'Position', [0.05, 0.19, 0.90, 0.30], ...
        'BackgroundColor', panel_bg, 'Style', 'frame');
    handles.lbl_debrief = uicontrol(f, 'unit', 'normalized', 'Position', [0.08, 0.43, 0.84, 0.04], ...
        'BackgroundColor', panel_bg, 'ForegroundColor', text_white, 'FontWeight', 'bold', 'FontSize', 14, ...
        'HorizontalAlignment', 'left', 'Style', 'text', 'String', 'INCIDENT DEBRIEF');
    handles.lbl_incident_k = uicontrol(f, 'unit', 'normalized', 'Position', [0.08, 0.37, 0.16, 0.04], ...
        'BackgroundColor', panel_bg, 'ForegroundColor', text_red, 'FontSize', 12, 'HorizontalAlignment', 'left', 'Style', 'text', 'String', 'Incident:');
    handles.lbl_incident_v = uicontrol(f, 'unit', 'normalized', 'Position', [0.24, 0.37, 0.68, 0.04], ...
        'BackgroundColor', panel_bg, 'ForegroundColor', text_white, 'FontSize', 12, 'HorizontalAlignment', 'left', 'Style', 'text', 'String', '', 'Tag', 'lbl_incident_v');
    handles.lbl_evidence_k = uicontrol(f, 'unit', 'normalized', 'Position', [0.08, 0.31, 0.16, 0.04], ...
        'BackgroundColor', panel_bg, 'ForegroundColor', text_white, 'FontSize', 12, 'HorizontalAlignment', 'left', 'Style', 'text', 'String', 'Evidence:');
    handles.lbl_evidence_v = uicontrol(f, 'unit', 'normalized', 'Position', [0.24, 0.30, 0.68, 0.06], ...
        'BackgroundColor', panel_bg, 'ForegroundColor', text_white, 'FontSize', 11, 'HorizontalAlignment', 'left', 'Style', 'text', 'String', '', 'Tag', 'lbl_evidence_v');
    handles.lbl_lesson_k = uicontrol(f, 'unit', 'normalized', 'Position', [0.08, 0.24, 0.16, 0.04], ...
        'BackgroundColor', panel_bg, 'ForegroundColor', text_white, 'FontSize', 12, 'HorizontalAlignment', 'left', 'Style', 'text', 'String', 'Lesson:');
    handles.lbl_lesson_v = uicontrol(f, 'unit', 'normalized', 'Position', [0.24, 0.23, 0.68, 0.06], ...
        'BackgroundColor', panel_bg, 'ForegroundColor', text_white, 'FontSize', 11, 'HorizontalAlignment', 'left', 'Style', 'text', 'String', '', 'Tag', 'lbl_lesson_v');
    handles.lbl_resource_url = uicontrol(f, 'unit', 'normalized', 'Position', [0.08, 0.195, 0.60, 0.03], ...
        'BackgroundColor', panel_bg, 'ForegroundColor', text_white, 'FontSize', 9, 'HorizontalAlignment', 'left', 'Style', 'text', 'String', '', 'Tag', 'lbl_resource_url');

    handles.btn_learn = uicontrol(f, 'unit', 'normalized', 'Position', [0.71, 0.19, 0.21, 0.05], ...
        'BackgroundColor', btn_blue, 'ForegroundColor', [1, 1, 1], 'FontSize', 11, ...
        'Style', 'pushbutton', 'String', 'Learn More', 'Tag', 'btn_learn', 'Callback', 'btn_learn_callback()');

    // ==========================================
    // BUTTONS
    // ==========================================
    // Play Again Button (Blue)
    handles.btn_replay = uicontrol(f, 'unit', 'normalized', 'Position', [0.20, 0.06, 0.28, 0.08], ...
        'BackgroundColor', btn_blue, 'ForegroundColor', [1, 1, 1], 'FontSize', 14, ...
        'Style', 'pushbutton', 'String', 'Play Again', 'Tag', 'btn_replay', 'Callback', 'btn_replay_callback()');

    // Main Menu Button (Dark Gray)
    handles.btn_menu = uicontrol(f, 'unit', 'normalized', 'Position', [0.52, 0.06, 0.28, 0.08], ...
        'BackgroundColor', panel_bg, 'ForegroundColor', text_white, 'FontSize', 14, ...
        'Style', 'pushbutton', 'String', 'Main Menu', 'Tag', 'btn_menu', 'Callback', 'btn_menu_callback()');

    END_FIG = f;
    f.visible = "on";
endfunction

function btn_replay_callback()
    global END_FIG
    reset_game_state();
    go_to_game();
endfunction

function btn_menu_callback()
    global END_FIG
    go_to_main_menu();
endfunction

function btn_learn_callback()
    global GAME
    // URLs are fixed, curated values in logic/incidents.sci.
    // Use cross-platform helper to open URL and surface failures.
    try
        url = GAME.incident.url;
    catch
        url = '';
    end

    if url == '' then
        messagebox('No resource URL available for this incident.', 'No URL', 'warn');
        return
    end

    try
        ok = open_url(url);
        if ~ok then
            messagebox('Failed to open URL: ' + url, 'Open URL', 'error');
        end
    catch
        messagebox('Unexpected error while opening URL.', 'Open URL', 'error');
    end
endfunction
