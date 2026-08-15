var _total_levels = array_length(global.LEVEL_TABLE);
var _start_idx = current_page * items_per_page;
var _end_idx = min(_start_idx + items_per_page, _total_levels);

window_set_cursor(cr_default)
window_mouse_set_locked(false)

for (var i = _start_idx; i < _end_idx; i++) {
    var _local_idx = i - _start_idx;
    var _col = _local_idx mod 2;
    var _row = _local_idx div 2;

    var _bx = start_x + (_col * spacing_x);
    var _by = start_y + (_row * spacing_y);

    var _is_hovered = point_in_rectangle(mouse_x, mouse_y, _bx - box_w/2, _by - box_h/2, _bx + box_w/2, _by + box_h/2);
    
    hover_states[i] = lerp(hover_states[i], _is_hovered ? 1 : 0, 0.2);

    if (_is_hovered && mouse_check_button_pressed(mb_left)) {
        transition_to_room(global.LEVEL_TABLE[i].room);
		
		game_state_resume(); 
		
		window_set_cursor(cr_none)
		window_mouse_set_locked(true)
		
    }
}

if (keyboard_check_pressed(vk_right) && _end_idx < _total_levels) current_page++;
if (keyboard_check_pressed(vk_left) && current_page > 0) current_page--;

