exec('logic/state.sci');
exec('logic/traffic.sci');
exec('logic/telemetry.sci');
exec('logic/capacity.sci');
exec('logic/health.sci');
exec('logic/events.sci');
exec('logic/actions.sci');
exec('logic/incidents.sci');
exec('logic/ui_refresh.sci');
exec('logic/navigation.sci');
exec('logic/open_url.sci');

// Load all screen builder + callback functions ONCE, at top level,
// so they stay in global scope permanently
exec('gui/screen_main_menu.sce');
exec('gui/screen_game.sce');
exec('gui/screen_end.sce');

global MENU_FIG GAME_FIG END_FIG
MENU_FIG = [];
GAME_FIG = [];
END_FIG = [];

go_to_main_menu();
