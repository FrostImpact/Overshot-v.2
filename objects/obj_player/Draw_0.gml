if (!is_dead){
	if (flash_timer > 0 && (flash_timer % 4 > 1)) {

	    gpu_set_fog(true, c_white, 0, 1)
	    draw_sprite_ext(sprite_index, image_index, x, y, visual_xscale, visual_yscale, visual_angle, image_blend, image_alpha)
	    gpu_set_fog(false, c_white, 0, 1)
	} else {

	    if (invuln_timer > 0 && (invuln_timer % 8 > 3)) {
	        draw_set_alpha(0.5)
	    }
    
	    draw_sprite_ext(sprite_index, image_index, x, y, visual_xscale, visual_yscale, visual_angle, image_blend, image_alpha)
	    draw_set_alpha(1)
	}


	if (aim_check) {
	    var _dist = point_distance(0, 0, aim_drag_x, aim_drag_y)

	    var _launch_speed = min(_dist * launch_power_scale * 0.125, max_launch_speed)
	    var _dir = point_direction(0, 0, aim_drag_x, aim_drag_y)

	    var _power_ratio = _launch_speed / max_launch_speed
	    var _line_length = _launch_speed * 8

	    var _end_x = x + lengthdir_x(_line_length, _dir)
	    var _end_y = y + lengthdir_y(_line_length, _dir)

	    var _line_color = merge_color(c_yellow, c_red, _power_ratio)

	    draw_set_color(_line_color)
	    draw_set_alpha(0.8)
	    draw_line_width(x, y, _end_x, _end_y, 4)

	    var _tip_x = _end_x + lengthdir_x(12, _dir)
	    var _tip_y = _end_y + lengthdir_y(12, _dir)
	    var _left_x = _end_x + lengthdir_x(8, _dir + 90)
	    var _left_y = _end_y + lengthdir_y(8, _dir + 90)
	    var _right_x = _end_x + lengthdir_x(8, _dir - 90)
	    var _right_y = _end_y + lengthdir_y(8, _dir - 90)

	    draw_set_alpha(1)
	    draw_triangle(_tip_x, _tip_y, _left_x, _left_y, _right_x, _right_y, false)

	    draw_set_alpha(1)
	    draw_set_color(c_white)
	}
}

var _width_display = hp_bar_width * clamp(hp_display / hp_max, 0, 1);
var _width_actual  = hp_bar_width * clamp(hp / hp_max, 0, 1);

var _shadow_offset = 4;

draw_set_color(c_black);
draw_set_alpha(0.35);
draw_rectangle(hp_bar_x + _shadow_offset, hp_bar_y + _shadow_offset, hp_bar_x + hp_bar_width + _shadow_offset, hp_bar_y + hp_bar_height + _shadow_offset, false);

draw_set_color(make_color_rgb(20, 24, 30));
draw_set_alpha(0.9);
draw_rectangle(hp_bar_x, hp_bar_y, hp_bar_x + hp_bar_width, hp_bar_y + hp_bar_height, false);

if (_width_display > 0) {
    draw_set_color(c_white);
    draw_set_alpha(0.85);
    draw_rectangle(hp_bar_x, hp_bar_y, hp_bar_x + _width_display, hp_bar_y + hp_bar_height, false);
}

if (_width_actual > 0) {
    draw_set_color($1D94F8);
    draw_set_alpha(1.0);
    draw_rectangle(hp_bar_x, hp_bar_y, hp_bar_x + _width_actual, hp_bar_y + hp_bar_height, false);

    draw_set_color(c_white);
    draw_set_alpha(0.25);
    draw_rectangle(hp_bar_x, hp_bar_y, hp_bar_x + _width_actual, hp_bar_y + max(1, hp_bar_height * 0.25), false);
}

draw_set_color(c_white);
draw_set_alpha(0.15);
draw_rectangle(hp_bar_x, hp_bar_y, hp_bar_x + hp_bar_width, hp_bar_y + hp_bar_height, true);

draw_set_alpha(1.0);
draw_set_color(c_white);