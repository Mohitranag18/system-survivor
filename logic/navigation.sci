global MENU_FIG GAME_FIG END_FIG

function close_if_open(fig_handle)
    if ~isempty(fig_handle) then
        try
            close(fig_handle);
        catch
        end
    end
endfunction

function go_to_main_menu()
    global MENU_FIG GAME_FIG END_FIG
    close_if_open(GAME_FIG); GAME_FIG = [];
    close_if_open(END_FIG); END_FIG = [];
    build_main_menu();
endfunction

function go_to_game()
    global MENU_FIG GAME_FIG END_FIG ARCH_AX
    close_if_open(MENU_FIG); MENU_FIG = [];
    close_if_open(END_FIG); END_FIG = [];
    build_game_screen();
    refresh_metrics();
    refresh_log();
    refresh_architecture();
endfunction

function go_to_end()
    global MENU_FIG GAME_FIG END_FIG
    close_if_open(GAME_FIG); GAME_FIG = [];
    build_end_screen();
    populate_end_screen();
endfunction
