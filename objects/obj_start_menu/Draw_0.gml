draw_set_font(font)

draw_clear(#E6D0BA); 

var _px = (mouse_x - room_width/2) * 0.02;
var _py = (mouse_y - room_height/2) * 0.02;

draw_set_color(#D4C0AB);
var _len = array_length(bg_particles);
for (var i = 0; i < _len; i++) {
    var _p = bg_particles[i];
    matrix_set(matrix_world, matrix_build(_p.x - _px, _p.y - _py, 0, 0, 0, _p.rot, _p.size/10, _p.size/10, 1));
    draw_rectangle(-10, -10, 10, 10, false);
}
matrix_set(matrix_world, matrix_build_identity());

var _banner_x1 = -300 - _px;
var _banner_y1 = room_height + 300 - _py;
var _banner_x2 = room_width + 300 - _px;
var _banner_y2 = -300 - _py;
var _banner_angle = point_direction(_banner_x1, _banner_y1, _banner_x2, _banner_y2);


if (anim_banner_width > 1) {
    draw_set_color(#C2AD98);
    draw_line_width(_banner_x1 + 15, _banner_y1 + 15, _banner_x2 + 15, _banner_y2 + 15, anim_banner_width);

    draw_set_color(#D24D28); 
    draw_line_width(_banner_x1, _banner_y1, _banner_x2, _banner_y2, anim_banner_width);
}


draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var _text_scale = 6; 
var _text_gap = (string_width("OVERSHOT") * _text_scale) + 150; 
var _scroll_offset = (time * 1.5) mod _text_gap; 

for (var i = -1; i <= 2; i++) {

    var _dist = (i * _text_gap) + _scroll_offset - (_text_gap / 2) + anim_text_offset; 
    
    var _tx = (room_width/2 - _px) + lengthdir_x(_dist, _banner_angle);
    var _ty = (room_height/2 - _py) + lengthdir_y(_dist, _banner_angle);

    draw_set_color(#A13515); 
    draw_text_transformed(_tx + 6, _ty + 6, "OVERSHOT", _text_scale, _text_scale, _banner_angle);

    draw_set_color(c_white);
    draw_text_transformed(_tx, _ty, "OVERSHOT", _text_scale, _text_scale, _banner_angle);
}


if (anim_btn_scale > 0.01) { 
    var _btn_x = (room_width / 2) - _px;
    var _btn_y = (room_height - 100) - _py;
    
    var _scale = anim_btn_scale + (hover_amt * 0.05);
    var _draw_w = 200 * _scale;
    var _draw_h = 60 * _scale;

    draw_set_color(#C2AD98);
    draw_rectangle(_btn_x - _draw_w/2 + 6, _btn_y - _draw_h/2 + 6, _btn_x + _draw_w/2 + 6, _btn_y + _draw_h/2 + 6, false);

    var _btn_color = merge_color(#F49D37, #FF6B35, hover_amt);
    draw_set_color(_btn_color);
    draw_rectangle(_btn_x - _draw_w/2, _btn_y - _draw_h/2, _btn_x + _draw_w/2, _btn_y + _draw_h/2, false);

    draw_set_color(c_white);
    draw_rectangle(_btn_x - _draw_w/2, _btn_y - _draw_h/2, _btn_x + _draw_w/2, _btn_y + _draw_h/2, true);

    draw_set_color(c_white);
    draw_text_transformed(_btn_x, _btn_y, "START", _scale, _scale, 0); 
}