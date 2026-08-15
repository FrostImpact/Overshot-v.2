if (!game_state_is_paused()) {
    
    if (is_spawning) {
        hp += 3; 
        hp_display = hp; 
        
        if (hp >= hp_max) {
            hp = hp_max;
            is_spawning = false
        }
    }

    if (hp <= 0 && !is_dead && !is_spawning) {
        player_trigger_death();
    }

    if (is_dead) {
        player_death_step();
        exit; 
    }
    
    game_state_update();

    physics_unstick(id, [obj_basic, obj_wall, obj_wall_invis], 32)

    var game_speed = game_state_get_speed()
    yspeed += gravity_force * game_speed
    xspeed = clamp(xspeed, -max_speed, max_speed)
    yspeed = clamp(yspeed, -max_speed, max_speed)

    if (mouse_check_button_pressed(mb_left)) {
        aim_check = true
        aim_drag_x = 0
        aim_drag_y = 0
        game_state_set_speed_mode(GameSpeedMode.AIMING)
        window_mouse_set(window_get_width() / 2, window_get_height() / 2)
    }

    if (aim_check) {
        aim_drag_x -= window_mouse_get_delta_x()
        aim_drag_y -= window_mouse_get_delta_y()

        if (mouse_check_button_released(mb_left)) {
            aim_check = false
            game_state_set_speed_mode(GameSpeedMode.NORMAL)

            var _launch_vel = launch_compute_velocity(aim_drag_x, aim_drag_y, launch_power_scale, max_launch_speed)
            xspeed = _launch_vel.hspd
            yspeed = _launch_vel.vspd
        }
    }

    var _move_x = xspeed * game_speed * slow
    var _move_y = yspeed * game_speed * slow

    if slow < 1 {
        particles_spawn_slime_trail(x, y)
    }

    var _avg_speed = point_distance(0, 0, xspeed, yspeed)
    var _speed_ratio = clamp(_avg_speed / max_speed, 0, 1)

    if (_avg_speed > 0.1) {
        visual_angle = point_direction(0, 0, xspeed, yspeed)
    }

    physics_resolve_axis(id, "x", _move_x, [obj_wall, obj_basic, obj_wall_invis], [obj_wall_hurt], bounce)
    physics_resolve_axis(id, "y", _move_y, [obj_wall, obj_basic, obj_wall_invis], [obj_wall_hurt], bounce)

    var _target_xscale = 1
    var _target_yscale = 1

    var _on_ground = place_meeting(x, y + 2, obj_wall)

    if (squash_timer > 0) {
        squash_timer -= 1
        var _squash_ratio = squash_timer / squash_duration
        _target_xscale = 1 - squash_amount * _squash_ratio
        _target_yscale = 1 + squash_amount * _squash_ratio
    } else if (_on_ground && abs(yspeed) <= 1) {
        _target_xscale = 1
        _target_yscale = 1
    } else {
        _target_xscale = 1 + stretch_amount * _speed_ratio
        _target_yscale = 1 - stretch_amount * _speed_ratio * 0.5
    }

    visual_xscale = lerp(visual_xscale, _target_xscale, scale_lerp_speed * game_speed)
    visual_yscale = lerp(visual_yscale, _target_yscale, scale_lerp_speed * game_speed)
    
    if (invuln_timer > 0) invuln_timer -= 1
    if (flash_timer > 0) flash_timer -= 1

    if (hp_delay_timer > 0) {
        hp_delay_timer -= 1
    } else {
        hp_display = lerp(hp_display, hp, 0.1)
    }
}