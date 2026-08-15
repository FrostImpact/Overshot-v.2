function level_config_init() {
    global.LEVEL_TABLE = [
		{ id: 0, room: Tutorial, name: "Tutorial", time_limit: 120, clear_target:1 },
        { id: 1, room: Level1, name: "Level 1", time_limit: 120, clear_target: 1 },
        { id: 2, room: Level2, name: "Level 2", time_limit: 70,  clear_target: 2 },
		{ id: 10, room: Boss1, name: "Boss - Sunder", time_limit: 999, clear_target: 1}
    ];
    
    global.clear = 0;
    global.level_completed = false;
   
    if (!variable_global_exists("game_state")) {
        game_state_init();
    }
}

function level_get_current() {
    var _len = array_length(global.LEVEL_TABLE);
    for (var i = 0; i < _len; i++) {
        if (global.LEVEL_TABLE[i].room == room) {
            return global.LEVEL_TABLE[i];
        }
    }
    return undefined;
}

function level_check_completion() {
    if (global.level_completed) return;

    var _cfg = level_get_current();
    if (_cfg == undefined) return;
    
    if (!variable_global_exists("clear")) global.clear = 0;

    if (global.clear >= _cfg.clear_target && _cfg.clear_target > 0) {
        global.level_completed = true;
        
        game_state_pause();
        
        if (!instance_exists(obj_next_level_arrow)) {
            instance_create_depth(0, 0, -10000, obj_next_level_arrow);
        }
    }
}

function level_goto_next() {
    var _current_idx = -1;
    var _len = array_length(global.LEVEL_TABLE);
    
    for (var i = 0; i < _len; i++) {
        if (global.LEVEL_TABLE[i].room == room) {
            _current_idx = i;
            break;
        }
    }
    
    if (_current_idx != -1 && _current_idx + 1 < _len) {
        var _next_level = global.LEVEL_TABLE[_current_idx + 1];
        
        global.clear = 0;
        global.level_completed = false;

        game_state_resume();
        
        transition_to_room(_next_level.room);
    }
}