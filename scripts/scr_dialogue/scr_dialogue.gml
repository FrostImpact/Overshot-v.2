function textbox_say(_text_array, _text_color = c_black, _pause_game = false, _duration = -1, _icon_sprite = -1) {
    if (!layer_exists("UI")) {
        layer_create(-9999, "UI");
    }

    if (!instance_exists(obj_text_box)) {
        instance_create_layer(0, 0, "UI", obj_text_box);
    }
    
    with (obj_text_box) {
        text_pages = _text_array;
        page_index = 0;
        char_index = 0;
        text_color = _text_color;
        auto_close_timer = _duration;
        auto_close_duration = _duration; 
        icon_sprite = _icon_sprite;
        
    }
}