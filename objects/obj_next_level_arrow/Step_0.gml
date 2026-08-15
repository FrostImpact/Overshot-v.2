anim_timer += 0.05;

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

for (var i = trail_max - 1; i > 0; i--) {
    trail_x[i] = trail_x[i - 1];
    trail_y[i] = trail_y[i - 1];
}
trail_x[0] = gui_x;
trail_y[0] = gui_y;

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _dist = point_distance(gui_x, gui_y, _mx, _my);

switch (state) {
    case "ENTER":
        gui_x = lerp(gui_x, target_x, fly_speed);
        gui_y = lerp(gui_y, target_y, fly_speed);
        scale_x = lerp(scale_x, 1.0, fly_speed);
        scale_y = lerp(scale_y, 1.0, fly_speed);
        angle = lerp(angle, 0, fly_speed);
        
        if (point_distance(gui_x, gui_y, target_x, target_y) < 3) {
            state = "IDLE";
        }
        break;

    case "IDLE":
        hovered = (_dist < 50);
        
        var _target_scale = hovered ? 1.3 : 1.0;
        scale_x = lerp(scale_x, _target_scale, 0.2);
        scale_y = lerp(scale_y, _target_scale, 0.2);
        
        var _target_angle = hovered ? -12 : 0;
        angle = lerp(angle, _target_angle, 0.2);

        if (hovered && mouse_check_button_pressed(mb_left)) {
            state = "EXIT";
            target_x = _gui_w + 350;
            target_y = _gui_h / 2;
            hovered = false;
        }
        break;

    case "EXIT":
	
        gui_x = lerp(gui_x, target_x, fly_speed);
        gui_y = lerp(gui_y, target_y, fly_speed);
        scale_x = lerp(scale_x, 1.0, fly_speed);
        scale_y = lerp(scale_y, 1.0, fly_speed);
        angle = lerp(angle, 0, fly_speed);

        if (point_distance(gui_x, gui_y, target_x, target_y) < 200) {
            level_goto_next();
            instance_destroy();
        }
        break;
}