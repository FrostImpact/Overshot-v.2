

for (var i = 1; i < trail_max; i++) {
    var _alpha = (1 - (i / trail_max)) * 0.35;
    var _trail_scale_x = scale_x * (1 - (i / trail_max) * 0.25);
    var _trail_scale_y = scale_y * (1 - (i / trail_max) * 0.25);
    
    var _trail_color = (state == "EXIT") ? c_orange : c_white;
    
    if (sprite_exists(sprite_index)) {
        draw_sprite_ext(sprite_index, 0, trail_x[i], trail_y[i], _trail_scale_x, _trail_scale_y, angle, _trail_color, _alpha);
    } else {

        draw_set_color(_trail_color);
        draw_set_alpha(_alpha);
        draw_circle(trail_x[i], trail_y[i], 28 * _trail_scale_x, false);
        draw_set_alpha(1.0);
    }
}

var _main_color = hovered ? c_yellow : ((state == "EXIT") ? c_orange : c_white);

if (sprite_exists(sprite_index)) {

    if (hovered || state == "EXIT") {
        draw_sprite_ext(sprite_index, 0, gui_x, gui_y, scale_x * 1.2, scale_y * 1.2, angle, c_yellow, 0.5);
    }
    draw_sprite_ext(sprite_index, 0, gui_x, gui_y, scale_x, scale_y, angle, _main_color, 1.0);
}