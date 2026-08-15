if (!game_state_is_paused()) {
    var game_speed = game_state_get_speed()

    if (place_meeting(x - 2, y, obj_player) || place_meeting(x + 2, y, obj_player) ||
        place_meeting(x, y - 2, obj_player) || place_meeting(x, y + 2, obj_player)) {
        
        var _player = instance_nearest(x, y, obj_player)
        if (_player != noone) {
            var _player_speed = point_distance(0, 0, _player.xspeed, _player.yspeed)
            
            if (_player_speed > 2) {
                var _impact_dir = point_direction(_player.x, _player.y, x, y)
                var _push_force = clamp(_player_speed * 0.35, 1, max_offset)
                
                offset_x = lengthdir_x(_push_force, _impact_dir)
                offset_y = lengthdir_y(_push_force, _impact_dir)
            }
        }
    }

    offset_x = lerp(offset_x, 0, offset_decay * game_speed)
    offset_y = lerp(offset_y, 0, offset_decay * game_speed)
}