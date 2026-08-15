if room = rm_level_select{ exit}


if (keyboard_check_pressed(vk_escape)) {
   
    if (variable_global_exists("level_completed") && global.level_completed) {
        //exit;
	}
	
	show_debug_message("PRESSED ESC")
	
    if (game_state_is_paused()) {
		
		show_debug_message("unpaused")
        game_state_resume();
		
    } else {
        game_state_pause();
		show_debug_message("paused")
    }
}

if (game_state_is_paused()) {
    if (mouse_check_button_pressed(mb_left)) {

        var _mx = device_mouse_x_to_gui(0);
        var _my = device_mouse_y_to_gui(0);
        
        if (point_in_rectangle(_mx, _my, 10, 10, 150, 60)) {
            game_state_resume(); 
			
			window_set_cursor(cr_default)
			window_mouse_set_locked(false)
			
            transition_to_room(rm_start);
        }
    }
}