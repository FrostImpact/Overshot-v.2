
if (state == SunderState.CLEAVE_WINDUP && telegraph_alpha > 0) {
    draw_set_color(c_red);
    draw_set_alpha(telegraph_alpha * 0.4);
    
    var _cleave_radius = 80; 
    var _angle_span = 90;   
    
    draw_primitive_begin(pr_trianglefan);
    draw_vertex(x, y); 
    for(var _i = -_angle_span/2; _i <= _angle_span/2; _i += 5) {
        draw_vertex(x + lengthdir_x(_cleave_radius, telegraph_angle + _i), y + lengthdir_y(_cleave_radius, telegraph_angle + _i));
    }
    draw_primitive_end();
    
    draw_set_alpha(telegraph_alpha);
    draw_primitive_begin(pr_linestrip);
    for(var _i = -_angle_span/2; _i <= _angle_span/2; _i += 10) {
        draw_vertex(x + lengthdir_x(_cleave_radius, telegraph_angle + _i), y + lengthdir_y(_cleave_radius, telegraph_angle + _i));
    }
    draw_primitive_end();
    
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}


if (state == SunderState.UNRELENTING_CHARGE && unrelenting_line_alpha > 0) {
    draw_set_alpha(unrelenting_line_alpha * 0.35);
    draw_line_width_color(x, y, unrelenting_line_x, unrelenting_line_y, 14, c_red, c_red);
    
    draw_set_alpha(unrelenting_line_alpha * 0.85);
    draw_line_width_color(x, y, unrelenting_line_x, unrelenting_line_y, 4, c_white, c_red);
    
    draw_set_alpha(unrelenting_line_alpha);
    draw_circle_color(unrelenting_line_x, unrelenting_line_y, 5, c_red, c_red, false);
    draw_set_alpha(1);
}

if (state == SunderState.PHASE_TRANSITION) {
    var _trans_ratio = state_timer / 60; 
    var _ring_radius = lerp(200, 0, power(_trans_ratio, 2));
    
    draw_set_color(c_orange);
    draw_set_alpha((1 - _trans_ratio) * 0.8);
    
    draw_circle(x, y, _ring_radius, true);
    draw_circle(x, y, _ring_radius + 8, true);
    
    draw_set_alpha(_trans_ratio * 0.5);
    draw_rectangle(x - 30, y - 30, x + 30, y + 30, true);
    
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}

if (state == SunderState.RICOCHET_STRIKE && state_timer < 15) {
    var _aim_alpha = state_timer / 15;
    var _laser_len = 1000; 
    var _lx = x + lengthdir_x(_laser_len, telegraph_angle);
    var _ly = y + lengthdir_y(_laser_len, telegraph_angle);
    
    draw_set_alpha(_aim_alpha * 0.7);

    draw_line_width_color(x, y, _lx, _ly, 2, c_red, c_red);
    draw_set_alpha(1.0);
}


if (state == SunderState.QUICK_SLASHES && quick_slash_phase == 0) {
    var _warn_alpha = quick_slash_timer / 15;
    if (instance_exists(obj_player)) {
        var _q_dir = point_direction(x, y, obj_player.x, obj_player.y);
        var _lx = x + lengthdir_x(150, _q_dir); // Shorter line for a quick dash
        var _ly = y + lengthdir_y(150, _q_dir);
        
        draw_set_alpha(_warn_alpha * 0.5);
        draw_line_width_color(x, y, _lx, _ly, 3, c_red, c_red);
        draw_set_alpha(1.0);
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