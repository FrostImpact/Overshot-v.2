function game_state_init() {
    global.game_state = {
        paused: false,
        speed_mode: GameSpeedMode.NORMAL,
        speed_multiplier: 1.0,
        hitstop_timer: 0,
        hitstop_speed_scale: 1.0
    }
}

function game_state_is_paused() {
    if (!variable_global_exists("game_state")) {
        game_state_init()
    }
    return global.game_state.paused
}

function game_state_pause() {
    if (!variable_global_exists("game_state")) {
        game_state_init()
    }
    global.game_state.paused = true
    game_state_set_speed_mode(GameSpeedMode.PAUSED)
}

function game_state_resume() {
    if (!variable_global_exists("game_state")) {
        game_state_init()
    }
    global.game_state.paused = false
    game_state_set_speed_mode(GameSpeedMode.NORMAL)
}

function game_state_set_speed_mode(mode) {
    if (!variable_global_exists("game_state")) {
        game_state_init()
    }
    global.game_state.speed_mode = mode
    
    switch (mode) {
        case GameSpeedMode.NORMAL:
            global.game_state.speed_multiplier = 1.0
			
			if room != rm_level_select or rm_start{
				window_set_cursor(cr_none)
				window_mouse_set_locked(true)
			}
			
            if (layer_exists("FX_Bullet_Time")) {
                layer_set_visible("FX_Bullet_Time", false)
            }
            break
            
        case GameSpeedMode.AIMING:
            global.game_state.speed_multiplier = 0.2
			
            if (layer_exists("FX_Bullet_Time")) {
                layer_set_visible("FX_Bullet_Time", true)
            }
            break
            
        case GameSpeedMode.BOSS_SLOW:
            global.game_state.speed_multiplier = 0.5
            
            if (layer_exists("FX_Bullet_Time")) {
                layer_set_visible("FX_Bullet_Time", true)
            }
            break
            
        case GameSpeedMode.PAUSED:
            global.game_state.speed_multiplier = 0.0
            
            window_set_cursor(cr_default)
			window_mouse_set_locked(false)
			
            if (layer_exists("FX_Bullet_Time")) {
                layer_set_visible("FX_Bullet_Time", true)
            }
			
            break
    }
}

function game_state_set_hitstop(duration_frames, time_scale) {
    if (!variable_global_exists("game_state")) {
        game_state_init()
    }
    global.game_state.hitstop_timer = duration_frames
    global.game_state.hitstop_speed_scale = time_scale
}

function game_state_update() {
    if (!variable_global_exists("game_state")) {
        game_state_init()
    }
    
    if (!global.game_state.paused && global.game_state.hitstop_timer > 0) {
        global.game_state.hitstop_timer -= 1;
    }
}

function game_state_get_speed() {
    if (!variable_global_exists("game_state")) {
        game_state_init()
    }
    
    var _current_speed = global.game_state.speed_multiplier;
    
    if (global.game_state.hitstop_timer > 0) {
        return _current_speed * global.game_state.hitstop_speed_scale;
    }
    
    return _current_speed;
}