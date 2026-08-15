if (flash_timer > 0) {
    gpu_set_fog(true, c_white, 0, 1);
    draw_self();
    gpu_set_fog(false, c_white, 0, 1);
} else {
    draw_self(); //ED4040
}

if (!is_dead) {
    var _bar_width = 48;
    var _bar_height = 6;
    var _bar_x = x - _bar_width / 2;
    var _bar_y = y - sprite_height / 2 - 12;

    var _width_display = _bar_width * clamp(enemy_hp_display / enemy_max_hp, 0, 1);
    var _width_actual  = _bar_width * clamp(enemy_hp / enemy_max_hp, 0, 1);
    var _shadow_offset = 2; 

    draw_set_color(c_black);
    draw_set_alpha(0.35);
    draw_rectangle(_bar_x + _shadow_offset, _bar_y + _shadow_offset, _bar_x + _bar_width + _shadow_offset, _bar_y + _bar_height + _shadow_offset, false);

    draw_set_color(make_color_rgb(20, 24, 30));
    draw_set_alpha(0.9);
    draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_width, _bar_y + _bar_height, false);

    if (_width_display > 0) {
        draw_set_color(c_white);
        draw_set_alpha(0.85);
        draw_rectangle(_bar_x, _bar_y, _bar_x + _width_display, _bar_y + _bar_height, false);
    }

    if (_width_actual > 0) {
        draw_set_color(c_lime); 
        draw_set_alpha(1.0);
        draw_rectangle(_bar_x, _bar_y, _bar_x + _width_actual, _bar_y + _bar_height, false);

        draw_set_color(c_white);
        draw_set_alpha(0.25);
        draw_rectangle(_bar_x, _bar_y, _bar_x + _width_actual, _bar_y + max(1, _bar_height * 0.25), false);
    }

    draw_set_color(c_white);
    draw_set_alpha(0.15);
    draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_width, _bar_y + _bar_height, true);

    draw_set_alpha(1.0);
    draw_set_color(c_white);
}