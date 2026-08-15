if (!variable_global_exists("LEVEL_TABLE")) {
    level_config_init(); 
}

current_page = 0;
items_per_page = 6;
box_w = 180;
box_h = 120;
spacing_x = 220;
spacing_y = 160;

start_x = (room_width / 2) - (spacing_x / 2);
start_y = (room_height / 2) - (spacing_y / 2);

var _total_levels = array_length(global.LEVEL_TABLE);
hover_states = array_create(_total_levels, 0);
