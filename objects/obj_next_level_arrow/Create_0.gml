

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

gui_x = -200;
gui_y = _gui_h / 2;

target_x = _gui_w / 2;
target_y = _gui_h / 2;

state = "ENTER";

fly_speed = 0.08;
exit_speed = 5;

scale_x = 1.0;
scale_y = 1.0;
angle = 0;
hovered = false;
anim_timer = 0;
pulse = 0;

trail_max = 8;
trail_x = array_create(trail_max, gui_x);
trail_y = array_create(trail_max, gui_y);