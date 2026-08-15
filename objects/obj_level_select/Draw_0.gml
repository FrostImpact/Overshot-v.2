
draw_clear(#E6D0BA); 

var _total_levels = array_length(global.LEVEL_TABLE);
var _start_idx = current_page * items_per_page;
var _end_idx = min(_start_idx + items_per_page, _total_levels);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

for (var i = _start_idx; i < _end_idx; i++) {
    var _level = global.LEVEL_TABLE[i];
    var _local_idx = i - _start_idx;
    var _col = _local_idx mod 2;
    var _row = _local_idx div 2;

    var _bx = start_x + (_col * spacing_x);
    var _by = start_y + (_row * spacing_y);

    var _h_amt = hover_states[i];
    var _scale = 1 + (_h_amt * 0.05); 
    var _w = box_w * _scale;
    var _h = box_h * _scale;

    draw_set_color(#C2AD98);
    draw_rectangle(_bx - _w/2 + 6, _by - _h/2 + 6, _bx + _w/2 + 6, _by + _h/2 + 6, false);

    var _box_color = merge_color(#8CB369, #F49D37, _h_amt);
    draw_set_color(_box_color);
    draw_rectangle(_bx - _w/2, _by - _h/2, _bx + _w/2, _by + _h/2, false);

    draw_set_color(c_white);
    draw_rectangle(_bx - _w/2, _by - _h/2, _bx + _w/2, _by + _h/2, true);

    draw_set_color(c_white);
    draw_text_transformed(_bx, _by, _level.name, _scale, _scale, 0);
}

var _total_pages = ceil(_total_levels / items_per_page);
draw_set_color(#E4572E); 
draw_text(room_width / 2, room_height - 60, "Page " + string(current_page + 1) + " of " + string(max(1, _total_pages)));
draw_set_color(#8C7A6B); 
draw_text(room_width / 2, room_height - 30, "Use Left/Right Arrows");