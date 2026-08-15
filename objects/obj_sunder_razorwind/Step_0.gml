if (game_state_is_paused()) exit;

var game_speed = game_state_get_speed();
x += lengthdir_x(speed * game_speed, direction);
y += lengthdir_y(speed * game_speed, direction);

image_angle = direction;

particle_spawn_dash_trail(x, y);
if (random(1) < 0.3) particle_spawn_spark(x, y, 1);

life_timer -= game_speed;
if (life_timer <= 0) {
    instance_destroy();
    exit;
}

if (instance_exists(obj_player)) {
    if (place_meeting(x, y, obj_player)) {
        if (obj_player.invuln_timer <= 0) {
			
			player_take_damage(damage, image_angle);
			
            obj_player.flash_timer = 15;
            obj_player.invuln_timer = 45;
            obj_player.hp_delay_timer = 20;
        }
        instance_destroy();
        exit;
    }
}

if (place_meeting(x, y, obj_wall)) {
    if (is_enhanced && !has_redirected && instance_exists(owner_id) && instance_exists(obj_player)) {
        has_redirected = true;
        squash_timer = squash_duration; 
        
        particle_spawn_spark(owner_id.x, owner_id.y, 20);
        owner_id.x = clamp(x, 40, room_width - 40);
        owner_id.y = clamp(y, 40, room_height - 40);
        owner_id.squash_timer = owner_id.squash_duration; 
        particle_spawn_spark(owner_id.x, owner_id.y, 20);
        
        direction = point_direction(x, y, obj_player.x, obj_player.y);
        speed *= 1.5;
        
        x += lengthdir_x(12, direction);
        y += lengthdir_y(12, direction);
    }
}


var _pad = 100; 
if (x < -_pad || x > room_width + _pad || y < -_pad || y > room_height + _pad) {
    instance_destroy();
}

if (squash_timer > 0) {
    squash_timer -= game_speed;
    var _sq = squash_timer / squash_duration;
    visual_scale_x = base_scale * (1 - 0.4 * _sq);
    visual_scale_y = base_scale * (1 + 0.4 * _sq);
} else {
    var _stretch = (speed / 15) * 0.3;
    visual_scale_x = lerp(visual_scale_x, base_scale * (1 + _stretch), 0.2);
    visual_scale_y = lerp(visual_scale_y, base_scale * (1 - _stretch), 0.2);
}