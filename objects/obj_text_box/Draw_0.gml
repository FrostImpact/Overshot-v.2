
if (page_index >= array_length(text_pages)) exit;

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

var _box_h = 120;
var _box_w = _gui_w - (margin * 4);
var _box_x = margin * 2;
var _box_y = _gui_h - _box_h - margin;

var _has_icon = (icon_sprite != -1 && sprite_exists(icon_sprite));
var _icon_size = 0;

if (_has_icon) {
    _icon_size = _box_h;
    _box_w -= (_icon_size + margin);
}

draw_set_alpha(0.6);
draw_set_color(make_color_rgb(222, 198, 176));

if (_has_icon) {
    draw_rectangle(_box_x, _box_y, _box_x + _icon_size, _box_y + _box_h, false);
}

var _text_box_x = _box_x + _icon_size + (_has_icon ? margin : 0);
draw_rectangle(_text_box_x, _box_y, _text_box_x + _box_w, _box_y + _box_h, false);

draw_set_alpha(1.0);

draw_set_color(c_white);
if (_has_icon) draw_rectangle(_box_x, _box_y, _box_x + _icon_size, _box_y + _box_h, true);
draw_rectangle(_text_box_x, _box_y, _text_box_x + _box_w, _box_y + _box_h, true);

draw_set_color(make_color_rgb(255, 160, 122)); 
if (_has_icon) draw_rectangle(_box_x - 2, _box_y - 2, _box_x + _icon_size + 2, _box_y + _box_h + 2, true);
draw_rectangle(_text_box_x - 2, _box_y - 2, _text_box_x + _box_w + 2, _box_y + _box_h + 2, true);

if (_has_icon) {
    draw_sprite_stretched(icon_sprite, 0, _box_x, _box_y, _icon_size, _icon_size);
}

draw_set_color(text_color);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _current_text = string_copy(text_pages[page_index], 1, floor(char_index));
draw_text_ext(_text_box_x + margin, _box_y + margin, _current_text, -1, _box_w - (margin * 2));