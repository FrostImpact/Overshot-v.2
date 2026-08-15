

if (state == TransitionState.SLIDING && sprite_exists(snapshot_sprite)) {
    var _w = display_get_gui_width();
    var _h = display_get_gui_height();

    var _smooth_progress = (1 - cos(pi * progress)) / 2; 
    
    var _x_offset = _w * _smooth_progress;
    
    draw_sprite_stretched(snapshot_sprite, 0, -_x_offset, 0, _w, _h);
}