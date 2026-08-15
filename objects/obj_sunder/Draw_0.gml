if (!is_dead) {
    var _gui_w = display_get_gui_width();
    
    var _bar_w = 500; 
    var _bar_h = 16; 
    var _bar_x = (_gui_w - _bar_w) / 2; 
    var _bar_y = 40;  
    
    var _width_display = _bar_w * clamp(enemy_hp_display / enemy_max_hp, 0, 1);
    var _width_actual  = _bar_w * clamp(enemy_hp / enemy_max_hp, 0, 1);

    draw_set_color(c_black);
    draw_set_alpha(0.8);
    draw_rectangle(_bar_x + 4, _bar_y + 4, _bar_x + _bar_w + 4, _bar_y + _bar_h + 4, false);

    draw_set_color(make_color_rgb(40, 10, 10));
    draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + _bar_h, false);

    if (_width_display > 0) {
        draw_set_color(c_white);
        draw_set_alpha(0.85);
        draw_rectangle(_bar_x, _bar_y, _bar_x + _width_display, _bar_y + _bar_h, false);
    }

    if (_width_actual > 0) {
        draw_set_color(is_phase_2 ? c_orange : make_color_rgb(220, 20, 60));
        draw_set_alpha(1.0);
        draw_rectangle(_bar_x, _bar_y, _bar_x + _width_actual, _bar_y + _bar_h, false);

        draw_set_color(c_white);
        draw_set_alpha(0.25);
        draw_rectangle(_bar_x, _bar_y, _bar_x + _width_actual, _bar_y + max(1, _bar_h * 0.25), false);
    }

    var _p2_x = _bar_x + (_bar_w * 0.50);
    draw_set_color(c_white);
    draw_set_alpha(1.0);
    draw_rectangle(_p2_x - 1, _bar_y - 4, _p2_x + 1, _bar_y + _bar_h + 4, false);

    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    
    var _boss_name = is_phase_2 ? "SUNDER (ENRAGED)" : "SUNDER, THE UNRELENTING";
    
    draw_set_color(c_black);
    draw_text(_gui_w / 2 + 1, _bar_y - 1 + 1, _boss_name);
    
    draw_set_color(is_phase_2 ? c_orange : c_white);
    draw_text(_gui_w / 2, _bar_y - 1, _boss_name);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}

if (state == SunderState.CLEAVE_WINDUP && telegraph_alpha > 0) {
    draw_set_color(c_red);
    draw_set_alpha(telegraph_alpha * 0.5);
    
    var _cleave_radius = 80; 
    var _angle_span = 90;   
    
    draw_primitive_begin(pr_trianglefan);
    draw_vertex(x, y); 
    for(var _i = -_angle_span/2; _i <= _angle_span/2; _i += 5) {
        draw_vertex(x + lengthdir_x(_cleave_radius, telegraph_angle + _i), y + lengthdir_y(_cleave_radius, telegraph_angle + _i));
    }
    draw_primitive_end();
    
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}

if (state == SunderState.UNRELENTING_CHARGE && unrelenting_line_alpha > 0) {
    draw_set_color(c_red);
    draw_set_alpha(unrelenting_line_alpha * 0.5);
    
    var _dir = point_direction(x, y, unrelenting_line_x, unrelenting_line_y);
    var _w_x = lengthdir_x(16, _dir + 90);
    var _w_y = lengthdir_y(16, _dir + 90);
    
    draw_primitive_begin(pr_trianglestrip);
    draw_vertex(x + _w_x, y + _w_y);
    draw_vertex(x - _w_x, y - _w_y);
    draw_vertex(unrelenting_line_x + _w_x, unrelenting_line_y + _w_y);
    draw_vertex(unrelenting_line_x - _w_x, unrelenting_line_y - _w_y);
    draw_primitive_end();
    
    draw_set_alpha(1);
    draw_set_color(c_white);
}

if (state == SunderState.PHASE_TRANSITION) {
    var _trans_ratio = state_timer / 60; 
    var _ring_radius = lerp(200, 0, power(_trans_ratio, 2));
    
    draw_set_color(c_orange);
    draw_set_alpha((1 - _trans_ratio) * 0.6);
    
    draw_circle(x, y, _ring_radius, false);
    
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}

if (state == SunderState.RICOCHET_STRIKE && state_timer < 15) {
    var _aim_alpha = state_timer / 15;
    var _laser_len = 1000; 
    
    draw_set_color(c_red);
    draw_set_alpha(_aim_alpha * 0.7);

    var _w_x = lengthdir_x(10, telegraph_angle + 90);
    var _w_y = lengthdir_y(10, telegraph_angle + 90);
    var _end_x = x + lengthdir_x(_laser_len, telegraph_angle);
    var _end_y = y + lengthdir_y(_laser_len, telegraph_angle);

    draw_primitive_begin(pr_trianglestrip);
    draw_vertex(x + _w_x, y + _w_y);
    draw_vertex(x - _w_x, y - _w_y);
    draw_vertex(_end_x + _w_x, _end_y + _w_y);
    draw_vertex(_end_x - _w_x, _end_y - _w_y);
    draw_primitive_end();
    
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}

if (state == SunderState.QUICK_SLASHES && quick_slash_phase == 0) {
    var _warn_alpha = quick_slash_timer / 15;
    
    if (instance_exists(obj_player)) {
        var _q_dir = point_direction(x, y, obj_player.x, obj_player.y);
        var _dist = min(point_distance(x, y, obj_player.x, obj_player.y), 150);
        var _lx = x + lengthdir_x(_dist, _q_dir); 
        var _ly = y + lengthdir_y(_dist, _q_dir);
        
        draw_set_color(c_red);
        draw_set_alpha(_warn_alpha * 0.85);
        
        var _size = 12 + (1 - _warn_alpha) * 15; 
        
        draw_primitive_begin(pr_trianglefan);
        draw_vertex(_lx, _ly - _size);
        draw_vertex(_lx + _size, _ly);
        draw_vertex(_lx, _ly + _size);
        draw_vertex(_lx - _size, _ly);
        draw_primitive_end();
        
        draw_set_alpha(1.0);
        draw_set_color(c_white);
    }
}

if (flash_timer > 0) {
    gpu_set_fog(true, c_white, 0, 1);
    draw_sprite_ext(sprite_index, image_index, x, y, visual_scale_x, visual_scale_y, visual_angle, image_blend, image_alpha);
    gpu_set_fog(false, c_white, 0, 1);
} else {
    var _blend = image_blend;
    if (_blend == c_white) {
        _blend = is_phase_2 ? c_orange : c_white;
    }
    
    draw_sprite_ext(sprite_index, image_index, x, y, visual_scale_x, visual_scale_y, visual_angle, _blend, image_alpha);
}