if (is_screen_split) {
    draw_set_color(c_white);
    draw_set_alpha(image_alpha);
    var _dx = lengthdir_x(1000, image_angle);
    var _dy = lengthdir_y(1000, image_angle);
    draw_line_width(x - _dx, y - _dy, x + _dx, y + _dy, 8 * image_alpha);
    draw_set_color(c_red);
    draw_line_width(x - _dx, y - _dy, x + _dx, y + _dy, 3 * image_alpha);
    draw_set_color(c_white);
    draw_set_alpha(1.0);
} else {
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_red, image_alpha);
}