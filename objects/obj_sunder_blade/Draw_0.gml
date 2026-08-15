draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, spin_angle, c_red, 0.85);

draw_set_color(c_red);
draw_set_alpha(0.3 + sin(current_time * 0.01) * 0.2);
draw_circle(x, y, 22, true);
draw_set_color(c_white);
draw_set_alpha(1.0);