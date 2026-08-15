if (!game_state_is_paused()) return;

var _total_rooms = array_length(rooms_list);
if (_total_rooms == 0) return;

if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
    selected_index = (selected_index - 1 + _total_rooms) % _total_rooms;
}
if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
    selected_index = (selected_index + 1) % _total_rooms;
}

if (mouse_wheel_up()) {
    selected_index = max(0, selected_index - 1);
}
if (mouse_wheel_down()) {
    selected_index = min(_total_rooms - 1, selected_index + 1);
}

if (selected_index < scroll_offset) {
    scroll_offset = selected_index;
} else if (selected_index >= scroll_offset + max_visible) {
    scroll_offset = selected_index - max_visible + 1;
}

var _confirm = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);

if (_confirm) {
    var _target_room = rooms_list[selected_index].id;
    game_state_resume();
    room_goto(_target_room);
}