clc;

f = figure("figure_name", "System Survivor - Test", "position", [100 100 600 400]);

label = uicontrol(f, "style", "text", "string", "Health: 100", "position", [20 340 150 30], "callback", "on_damage_click()");

btn = uicontrol(f, "style", "pushbutton", "string", "Damage System", "position", [20 300 150 30], "callback", "on_damage_click()");

function on_damage_click()
    disp("Button clicked!");
endfunction