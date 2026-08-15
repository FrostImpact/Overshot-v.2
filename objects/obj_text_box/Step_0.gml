if (game_state_is_paused()) { exit}

if (page_index < array_length(text_pages)) {
    var _target_length = string_length(text_pages[page_index]);
    
    if (char_index < _target_length) {
        char_index += text_speed;
    } else if (auto_close_timer > 0) {
        auto_close_timer--;
        if (auto_close_timer <= 0) {
            page_index++;
            char_index = 0;
            
            if (page_index >= array_length(text_pages)) {

                instance_destroy();
            } else {
                auto_close_timer = auto_close_duration;
            }
        }
    } else if (keyboard_check_pressed(vk_space)) {
        page_index++;
        char_index = 0;
        
        if (page_index >= array_length(text_pages)) {

            instance_destroy();
        } else {
            auto_close_timer = auto_close_duration;
        }
    }
}