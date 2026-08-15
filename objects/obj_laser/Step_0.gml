event_inherited()

if (game_state_is_paused()) exit;

var game_speed = game_state_get_speed()

if (instance_exists(obj_player)) {
    var _target_angle = point_direction(x, y, obj_player.x, obj_player.y)
    
    // Tracking rotation
    if (laser_state == LaserState.TRACKING) {
        laser_angle += angle_difference(_target_angle, laser_angle) * laser_track_rate * game_speed
    }
}

image_angle = laser_angle

// Firing state functions
switch (laser_state) {
    case LaserState.TRACKING:
        laser_timer += 1 * game_speed
        if (laser_timer >= tracking_duration) {
            laser_state = LaserState.LOCKED
            laser_timer = 0
        }
        break;
        
    case LaserState.LOCKED:
        laser_timer += 1 * game_speed
        if (laser_timer >= lock_duration) {
            laser_state = LaserState.FIRING
            laser_timer = 0
            kick_timer = kick_duration
        }
        break;
        
    case LaserState.FIRING:
        laser_timer += 1 * game_speed
        if (!has_hit_player && instance_exists(obj_player)) {
            var _dx = lengthdir_x(1, laser_angle)
            var _dy = lengthdir_y(1, laser_angle)
            var _tx = (_dx != 0) ? (((_dx > 0) ? room_width : 0) - x) / _dx : infinity
            var _ty = (_dy != 0) ? (((_dy > 0) ? room_height : 0) - y) / _dy : infinity
            var _t = min(_tx, _ty)
            var _end_x = x + _dx * _t
            var _end_y = y + _dy * _t
            
	if (collision_line(x, y, _end_x, _end_y, obj_player, false, false)) {
		var _hit_success = player_take_damage(laser_damage, laser_angle);
    
		if (_hit_success) {
			has_hit_player = true;
		}
	}
        }
        
    if (laser_timer >= fire_duration) {
            laser_state = LaserState.TRACKING
            laser_timer = 0
            has_hit_player = false
        }
        break;
}

// Fire recoil animation
if (kick_timer > 0) {
    kick_timer -= 1 * game_speed
    var _kick_ratio = kick_timer / kick_duration
    image_xscale = 1 + kick_amount * _kick_ratio
    image_yscale = 1 - kick_amount * _kick_ratio * 0.5
}