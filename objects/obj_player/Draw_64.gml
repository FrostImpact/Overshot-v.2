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