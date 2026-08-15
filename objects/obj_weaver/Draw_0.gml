var _main_color = is_phase_2 ? color_p2 : color_p1;

// 1. GHOST ECHO TRAIL
for (var _i = 0; _i < array_length(echo_trail); _i++) {
    var _e = echo_trail[_i];
    gpu_set_fog(true, _e.color, 0, 1);
    draw_sprite_ext(sprite_index, image_index, _e.x, _e.y, _e.scale_x, _e.scale_y, _e.angle, color_light, _e.alpha * 0.5);
    gpu_set_fog(false, color_light, 0, 1);
}

// 2. WEAVER WALLS
for (var _i = 0; _i < array_length(weaver_walls); _i++) {
    var _w = weaver_walls[_i];
    draw_set_alpha(0.6);
    draw_line_width_color(_w.x1, _w.y1, _w.x2, _w.y2, _w.width + 4, _main_color, _main_color);
    
    draw_set_alpha(1.0);
    draw_line_width_color(_w.x1, _w.y1, _w.x2, _w.y2, max(2, _w.width - 2), color_light, color_light);

    draw_sprite_ext(sprite_index, 0, _w.x1, _w.y1, 0.4, 0.4, _w.dir + 45, color_light, 1.0);
    draw_sprite_ext(sprite_index, 0, _w.x2, _w.y2, 0.4, 0.4, _w.dir + 45, color_light, 1.0);
}

// 3. GEOMETRIC CONE DRILLS (No White, Cool Geometric Animation)
for (var _i = 0; _i < array_length(drills); _i++) {
    var _d = drills[_i];
    var _tip_x = _d.x + lengthdir_x(_d.radius * 2.5, _d.dir);
    var _tip_y = _d.y + lengthdir_y(_d.radius * 2.5, _d.dir);
    var _back_x = _d.x - lengthdir_x(_d.radius * 0.8, _d.dir);
    var _back_y = _d.y - lengthdir_y(_d.radius * 0.8, _d.dir);

    // Core Spear Axis
    draw_line_width_color(_back_x, _back_y, _tip_x, _tip_y, 4, color_light, color_light);

    // Rotating geometric overlapping chevrons that travel along the spear
    for (var _k = 0; _k < 4; _k++) {
        var _offset = (_d.rot + _k * 90) % 360;
        var _scale = 0.5 + 0.5 * dsin(_offset); // Flattens to simulate 3D Z-rotation
        var _pos_t = (_offset / 360); // Moves from back to tip
        
        var _cx = lerp(_back_x, _tip_x, _pos_t);
        var _cy = lerp(_back_y, _tip_y, _pos_t);
        var _w = _d.radius * _scale;

        var _p1x = _cx + lengthdir_x(_w, _d.dir + 90);
        var _p1y = _cy + lengthdir_y(_w, _d.dir + 90);
        var _p2x = _cx + lengthdir_x(_w, _d.dir - 90);
        var _p2y = _cy + lengthdir_y(_w, _d.dir - 90);
        var _front_cx = lerp(_back_x, _tip_x, clamp(_pos_t + 0.25, 0, 1));
        var _front_cy = lerp(_back_y, _tip_y, clamp(_pos_t + 0.25, 0, 1));

        // Translucent main color body
        draw_set_alpha(0.85);
        draw_triangle_color(_p1x, _p1y, _p2x, _p2y, _front_cx, _front_cy, _main_color, _main_color, color_light, false);
        
        // Deep purple framework
        draw_set_alpha(1.0);
        draw_line_width_color(_p1x, _p1y, _front_cx, _front_cy, 2, color_dark, color_dark);
        draw_line_width_color(_p2x, _p2y, _front_cx, _front_cy, 2, color_dark, color_dark);
        draw_line_width_color(_p1x, _p1y, _p2x, _p2y, 2, color_dark, color_dark);
    }
}

// 4. NEEDLES
for (var _i = 0; _i < array_length(needles); _i++) {
    var _n = needles[_i];
    var _tail_x = _n.x - lengthdir_x(28, _n.dir);
    var _tail_y = _n.y - lengthdir_y(28, _n.dir);

    draw_set_alpha(0.6);
    draw_line_width_color(_tail_x, _tail_y, _n.x, _n.y, 5, _main_color, _main_color);
    
    draw_set_alpha(1.0);
    draw_line_width_color(_tail_x, _tail_y, _n.x, _n.y, 2, color_light, color_light);

    draw_primitive_begin(pr_trianglefan);
    draw_vertex_color(_n.x + lengthdir_x(12, _n.dir), _n.y + lengthdir_y(12, _n.dir), color_light, 1.0);
    draw_vertex_color(_n.x + lengthdir_x(5, _n.dir + 90), _n.y + lengthdir_y(5, _n.dir + 90), _main_color, 1.0);
    draw_vertex_color(_n.x - lengthdir_x(5, _n.dir), _n.y - lengthdir_y(5, _n.dir), color_light, 1.0);
    draw_vertex_color(_n.x + lengthdir_x(5, _n.dir - 90), _n.y + lengthdir_y(5, _n.dir - 90), _main_color, 1.0);
    draw_primitive_end();
}

// 5. SILK ECHOES (Passive)
for (var _i = 0; _i < array_length(silk_echoes); _i++) {
    var _e = silk_echoes[_i];
    var _ratio = _e.timer / _e.max_timer;
    var _size = 10 + (_ratio * 22); 
    var _rot = _ratio * 180;
    var _alpha = 1.0 - (_ratio * 0.4);
    
    draw_set_alpha(_alpha);
    draw_primitive_begin(pr_linestrip);
    draw_vertex_color(_e.x + lengthdir_x(_size, _rot), _e.y + lengthdir_y(_size, _rot), _main_color, _alpha);
    draw_vertex_color(_e.x + lengthdir_x(_size, _rot + 90), _e.y + lengthdir_y(_size, _rot + 90), color_light, _alpha);
    draw_vertex_color(_e.x + lengthdir_x(_size, _rot + 180), _e.y + lengthdir_y(_size, _rot + 180), _main_color, _alpha);
    draw_vertex_color(_e.x + lengthdir_x(_size, _rot + 270), _e.y + lengthdir_y(_size, _rot + 270), color_light, _alpha);
    draw_vertex_color(_e.x + lengthdir_x(_size, _rot), _e.y + lengthdir_y(_size, _rot), _main_color, _alpha);
    draw_primitive_end();
    
    if (_ratio < 0.25) draw_circle_color(_e.x, _e.y, 3, color_light, color_light, false);
    draw_set_alpha(1.0);
}

// 6. ATTACK TELEGRAPH LINES
if (state == WeaverState.PRE_ATTACK && telegraph_alpha > 0) {
    var _lx = x + lengthdir_x(450, telegraph_dir);
    var _ly = y + lengthdir_y(450, telegraph_dir);

    draw_set_alpha(telegraph_alpha * 0.4);
    draw_line_width_color(x, y, _lx, _ly, 4, color_dark, color_dark);
    draw_set_alpha(telegraph_alpha * 0.9);
    draw_line_width_color(x, y, _lx, _ly, 1.5, color_light, color_light);
    draw_set_alpha(1.0);
}

// 7. PHASE TRANSITION FX
if (state == WeaverState.PHASE_TRANSITION) {
    var _trans_ratio = state_timer / 50;
    var _ring_radius = lerp(200, 0, power(_trans_ratio, 2));

    draw_set_alpha((1 - _trans_ratio) * 0.9);
    draw_circle_color(x, y, _ring_radius, color_light, color_light, true);
    draw_circle_color(x, y, _ring_radius + 4, _main_color, _main_color, true);
    draw_set_alpha(1.0);
}

// MAIN BOSS SPRITE
if (flash_timer > 0) {
    gpu_set_fog(true, color_light, 0, 1);
    draw_sprite_ext(sprite_index, image_index, x, y, visual_scale_x, visual_scale_y, visual_angle, image_blend, image_alpha);
    gpu_set_fog(false, color_light, 0, 1);
} else {
    var _blend = (image_blend == c_white) ? color_light : image_blend;
    draw_sprite_ext(sprite_index, image_index, x, y, visual_scale_x, visual_scale_y, visual_angle, _blend, image_alpha);
}