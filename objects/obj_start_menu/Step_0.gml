time++;
intro_timer++; 

window_set_cursor(cr_default)
window_mouse_set_locked(false)


anim_banner_width = lerp(anim_banner_width, 250, 0.15);

if (intro_timer > 15) {
    anim_text_offset = lerp(anim_text_offset, 0, 0.2);
}

if (intro_timer > 40) {
    anim_btn_scale = lerp(anim_btn_scale, 1.0, 0.25);
}



var _len = array_length(bg_particles);
for (var i = 0; i < _len; i++) {
    var _p = bg_particles[i];
    _p.y -= _p.spd;
    _p.rot += _p.rot_spd;
    
    if (_p.y < -50) {
        _p.y = room_height + 50;
        _p.x = random(room_width);
    }
}

var _px = (mouse_x - room_width/2) * 0.02;
var _py = (mouse_y - room_height/2) * 0.02;

if (anim_btn_scale > 0.9) {
    var _btn_x = (room_width / 2) - _px;
    var _btn_y = (room_height - 100) - _py; 
    var _btn_w = 200;
    var _btn_h = 60;

    var _is_hovered = point_in_rectangle(mouse_x, mouse_y, _btn_x - _btn_w/2, _btn_y - _btn_h/2, _btn_x + _btn_w/2, _btn_y + _btn_h/2);
    hover_amt = lerp(hover_amt, _is_hovered ? 1 : 0, 0.2);

    if (_is_hovered && mouse_check_button_pressed(mb_left)) {
        transition_to_room(rm_level_select);
    }
}