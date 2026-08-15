if (!game_state_is_paused()) return;

var _total_rooms = array_length(rooms_list);
var _visible_count = min(_total_rooms, max_visible);
var _panel_h = (_visible_count * item_height) + 40;

var _panel_x1 = 1100;
var _panel_y1 = 20;
var _panel_x2 = _panel_x1 + panel_width;
var _panel_y2 = _panel_y1 + _panel_h;

draw_set_color(make_color_rgb(22, 25, 34));
draw_set_alpha(0.9);
draw_roundrect_ext(_panel_x1, _panel_y1, _panel_x2, _panel_y2, 8, 8, false);

draw_set_color(make_color_rgb(70, 130, 210));
draw_roundrect_ext(_panel_x1, _panel_y1, _panel_x2, _panel_y2, 8, 8, true);

draw_set_alpha(1.0);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_text_transformed(_panel_x1 + 12, _panel_y1 + 10, "ROOM SELECTOR", 1.0, 1.0, 0);

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

var _start_y = _panel_y1 + 32;
draw_set_valign(fa_middle);

for (var i = 0; i < _visible_count; i++) {
    var _idx = scroll_offset + i;
    if (_idx >= _total_rooms) break;

    var _room_struct = rooms_list[_idx];
    var _rx1 = _panel_x1 + 8;
    var _ry1 = _start_y + (i * item_height);
    var _rx2 = _panel_x2 - 8;
    var _ry2 = _ry1 + item_height - 4;

    var _is_hovered = (_mx >= _rx1 && _mx <= _rx2 && _my >= _ry1 && _my <= _ry2);
    if (_is_hovered) {
        selected_index = _idx;
        if (mouse_check_button_pressed(mb_left)) {
            game_state_resume();
            room_goto(_room_struct.id);
            return;
        }
    }

    var _is_selected = (selected_index == _idx);
    var _is_current_room = (_room_struct.id == room);

    if (_is_selected) {
        draw_set_color(make_color_rgb(50, 90, 160));
        draw_set_alpha(0.85);
        draw_roundrect(_rx1, _ry1, _rx2, _ry2, false);
        draw_set_color(c_yellow);
    } else if (_is_current_room) {
        draw_set_color(make_color_rgb(35, 65, 45));
        draw_set_alpha(0.6);
        draw_roundrect(_rx1, _ry1, _rx2, _ry2, false);
        draw_set_color(make_color_rgb(120, 220, 140));
    } else {
        draw_set_color(c_white);
    }

    draw_set_alpha(1.0);
    var _label = _room_struct.name + (_is_current_room ? " *" : "");
    draw_text(_rx1 + 8, (_ry1 + _ry2) / 2, _label);
}

if (_total_rooms > max_visible) {
    var _sb_height = (_panel_h - 40);
    var _bar_h = max(8, (_visible_count / _total_rooms) * _sb_height);
    var _bar_y = _panel_y1 + 32 + ((scroll_offset / (_total_rooms - _visible_count)) * (_sb_height - _bar_h));
    
    draw_set_color(c_gray);
    draw_set_alpha(0.5);
    draw_rectangle(_panel_x2 - 5, _bar_y, _panel_x2 - 3, _bar_y + _bar_h, false);
}

draw_set_alpha(1.0);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);