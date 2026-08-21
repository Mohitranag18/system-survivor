function build_main_menu()
    global MENU_FIG

    bg_color = [0.12, 0.13, 0.16];
    btn_blue = [0.25, 0.45, 0.75];
    text_blue = [0.35, 0.65, 0.90];
    text_white = [0.85, 0.85, 0.85];

    f=figure('figure_position',[200,100],'figure_size',[600,750],'auto_resize','on','backgroundcolor',bg_color,'figure_name','System Survivor','dockable','off','infobar_visible','off','toolbar_visible','off','menubar_visible','off','default_axes','on','visible','off');

    handles.dummy = 0;

    handles.lbl_title=uicontrol(f,'unit','normalized','BackgroundColor',bg_color,'Enable','on','FontAngle','normal','FontName','Adwaita Sans','FontSize',[32],'FontUnits','points','FontWeight','bold','ForegroundColor',text_blue,'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.1,0.75,0.8,0.12],'Relief','default','SliderStep',[0.01,0.1],'String','SYSTEM SURVIVOR','Style','text','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','lbl_title','Callback','')

    handles.lbl_subtitle=uicontrol(f,'unit','normalized','BackgroundColor',bg_color,'Enable','on','FontAngle','normal','FontName','Adwaita Sans','FontSize',[14],'FontUnits','points','FontWeight','normal','ForegroundColor',text_white,'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.1,0.65,0.8,0.06],'Relief','default','SliderStep',[0.01,0.1],'String','A System Design Survival Game','Style','text','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','lbl_subtitle','Callback','')

    handles.btn_start=uicontrol(f,'unit','normalized','BackgroundColor',btn_blue,'Enable','on','FontAngle','normal','FontName','Adwaita Sans','FontSize',[14],'FontUnits','points','FontWeight','normal','ForegroundColor',[1,1,1],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.25,0.48,0.5,0.08],'Relief','default','SliderStep',[0.01,0.1],'String','Start Game','Style','pushbutton','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','btn_start','Callback','btn_start_callback()')

    handles.btn_howto=uicontrol(f,'unit','normalized','BackgroundColor',bg_color,'Enable','on','FontAngle','normal','FontName','Adwaita Sans','FontSize',[14],'FontUnits','points','FontWeight','normal','ForegroundColor',text_blue,'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.25,0.36,0.5,0.08],'Relief','default','SliderStep',[0.01,0.1],'String','How to Play','Style','pushbutton','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','btn_howto','Callback','btn_howto_callback()')

    handles.btn_quit=uicontrol(f,'unit','normalized','BackgroundColor',bg_color,'Enable','on','FontAngle','normal','FontName','Adwaita Sans','FontSize',[14],'FontUnits','points','FontWeight','normal','ForegroundColor',[1,1,1],'HorizontalAlignment','center','ListboxTop',[],'Max',[1],'Min',[0],'Position',[0.25,0.24,0.5,0.08],'Relief','default','SliderStep',[0.01,0.1],'String','Quit','Style','pushbutton','Value',[0],'VerticalAlignment','middle','Visible','on','Tag','btn_quit','Callback','btn_quit_callback()')

    MENU_FIG = f;
    f.visible = "on";
endfunction

function btn_start_callback()
    global MENU_FIG
    init_game_state();
    go_to_game();
endfunction

function btn_howto_callback()
    msg = ['SYSTEM SURVIVOR — HOW TO PLAY'; ..
           ''; ..
           'You are running a live web service. Each turn,'; ..
           'traffic changes and your architecture either'; ..
           'handles it or does not.'; ..
           ''; ..
           'Use the Action buttons to scale your system:'; ..
           'add servers, caching, load balancing, DB'; ..
           'replicas, CDN, or sharding — each costs budget.'; ..
           ''; ..
           'Inspect request arrows, per-server RPS, and'; ..
           'component utilization to find pressure points.'; ..
           'Colors show healthy, warning, and overloaded'; ..
           'components. The event log reports symptoms,'; ..
           'not recommended upgrades.'; ..
           ''; ..
           'Watch System Health. If it hits 0, your'; ..
           'system goes down. Survive 15 turns to win.'; ..
           ''; ..
           'Click Next Turn to advance the simulation.'];
    messagebox(msg, 'How to Play', 'info');
endfunction

function btn_quit_callback()
    global MENU_FIG
    close_if_open(MENU_FIG);
endfunction
