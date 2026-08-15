


var col_soft_red   = $4040ED
var col_soft_light = $4040ED

var _dx = lengthdir_x(1, laser_angle)
var _dy = lengthdir_y(1, laser_angle)
var _tx = (_dx != 0) ? (((_dx > 0) ? room_width : 0) - x) / _dx : infinity
var _ty = (_dy != 0) ? (((_dy > 0) ? room_height : 0) - y) / _dy : infinity
var _t = min(_tx, _ty)
var _end_x = x + _dx * _t
var _end_y = y + _dy * _t

switch (laser_state) {
    case LaserState.TRACKING:

        draw_set_alpha(0.35)
        draw_set_color(col_soft_red)
        draw_line_width(x, y, _end_x, _end_y, 1)

        var _reticle_size = 4
        draw_primitive_begin(pr_linestrip)
            draw_vertex(_end_x, _end_y - _reticle_size)
            draw_vertex(_end_x + _reticle_size, _end_y)
            draw_vertex(_end_x, _end_y + _reticle_size)
            draw_vertex(_end_x - _reticle_size, _end_y)
            draw_vertex(_end_x, _end_y - _reticle_size)
        draw_primitive_end()
        break;

    case LaserState.LOCKED:

        var _flash_alpha = 0.4 + 0.4 * dsin(current_time * 0.8)
        draw_set_alpha(_flash_alpha)
        draw_set_color(col_soft_red)
        draw_line_width(x, y, _end_x, _end_y, 2)


        var _lock_ratio = laser_timer / lock_duration
        var _size = lerp(14, 3, _lock_ratio)
        
        draw_primitive_begin(pr_linestrip)
            draw_vertex(_end_x, _end_y - _size)
            draw_vertex(_end_x + _size, _end_y)
            draw_vertex(_end_x, _end_y + _size)
            draw_vertex(_end_x - _size, _end_y)
            draw_vertex(_end_x, _end_y - _size)
        draw_primitive_end()
        break;

    case LaserState.FIRING:
        var _fire_ratio = laser_timer / fire_duration
        var _fade = 1 - _fire_ratio
        

        var _outer_width = lerp(15, 0, _fire_ratio)
        var _inner_width = lerp(4, 0, _fire_ratio)

        draw_set_alpha(_fade * 0.7)
        draw_set_color(col_soft_red)
        draw_line_width(x, y, _end_x, _end_y, _outer_width)

        draw_set_alpha(_fade)
        draw_set_color(col_soft_light)
        draw_line_width(x, y, _end_x, _end_y, _inner_width)
        break;
}

draw_set_alpha(1)
draw_set_color(c_white)

event_inherited() 