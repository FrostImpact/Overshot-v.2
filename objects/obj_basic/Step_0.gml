if (!game_state_is_paused()) {
    var game_speed = game_state_get_speed()

    if (is_dead) {

        image_xscale += 0.1 * game_speed
        image_yscale += 0.1 * game_speed
        image_alpha -= 0.1 * game_speed
        
        if (image_alpha <= 0) {
            instance_destroy()
        }
        exit; 
    }

    if (hit_cooldown <= 0) {
        var _hit = false
        var _enemy_id = id

        with (obj_player) {
            if (place_meeting(x + xspeed, y, _enemy_id) || place_meeting(x, y + yspeed, _enemy_id)) {
                _hit = true
            }
        }

        if (_hit) {
            if (variable_global_exists("p_sys") && variable_global_exists("p_trail")) {
                part_particles_create(global.p_sys, x, y, global.p_trail, 15)
            }

            var _player_speed = point_distance(0, 0, obj_player.xspeed, obj_player.yspeed)
            var _damage = _player_speed * damage_scale

            if (_damage > 0) {
                enemy_hp -= _damage
                hit_cooldown = hit_cooldown_duration

                var _knock_dir = point_direction(obj_player.x, obj_player.y, x, y)
                knockback_x = lengthdir_x(_player_speed * knockback_force, _knock_dir)
                knockback_y = lengthdir_y(_player_speed * knockback_force, _knock_dir)

                hit_squash_timer = hit_squash_duration
                flash_timer = flash_duration

                if (enemy_hp <= 0 && !is_dead) {
                    if (variable_global_exists("clear")) {
                        global.clear += 1
                    }
                    is_dead = true
                }
            }
        }
    }

    if (hit_cooldown > 0) {
        hit_cooldown -= 1 * game_speed
    }

    if (!place_meeting(x + knockback_x, y, obj_wall)) {
        x += knockback_x * game_speed
    } else {
        knockback_x = 0
    }

    if (!place_meeting(x, y + knockback_y, obj_wall)) {
        y += knockback_y * game_speed
    } else {
        knockback_y = 0
    }

    x = clamp(x, 0, room_width)
    y = clamp(y, 0, room_height)

    knockback_x *= knockback_friction
    knockback_y *= knockback_friction

    if (flash_timer > 0) {
        flash_timer -= 1 * game_speed
    }
	
        enemy_hp_display = lerp(enemy_hp_display, enemy_hp, 0.1)
    
}