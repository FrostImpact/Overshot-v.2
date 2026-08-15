if (game_state_is_paused()) exit;

enemy_hp_display = lerp(enemy_hp_display, enemy_hp, 0.1);

var game_speed = game_state_get_speed();

if (is_dead) {
    textbox_say(["Death truly is...","...","...relentless."], c_maroon, true, 120, spr_sunder_icon);
    
    visual_scale_x += 0.05 * game_speed;
    visual_scale_y += 0.05 * game_speed;
    image_alpha  -= 0.03 * game_speed;
    if (image_alpha <= 0) instance_destroy();
    exit;
}

if (!balls){
    textbox_say(["Another one?","Lets see how long you last."], c_maroon, true, 120, spr_sunder_icon);
    balls = true
}

event_inherited();

var _player_exists = instance_exists(obj_player);
var _p_x = _player_exists ? obj_player.x : x;
var _p_y = _player_exists ? obj_player.y : y;

if (_player_exists && state != SunderState.RAZORWIND_SPIN 
    && state != SunderState.UNRELENTING_DASH 
    && state != SunderState.PHASE_TRANSITION) {
    visual_angle = point_direction(x, y, _p_x, _p_y);
    image_angle = visual_angle; 
}

var _hp_ratio = enemy_hp / enemy_max_hp;
if (!is_phase_2 && _hp_ratio <= 0.50 && state != SunderState.PHASE_TRANSITION) {
    state = SunderState.PHASE_TRANSITION;
    state_timer = 0;
    dash_timer = 0; 
    
    if (instance_exists(active_blade)) {
        particle_spawn_shatter(active_blade.x, active_blade.y, 10);
        instance_destroy(active_blade);
        active_blade = noone;
    }
}

if (cd_quick_slashes > 0) cd_quick_slashes -= game_speed;
if (cd_razorwind > 0)     cd_razorwind -= game_speed;
if (cd_ricochet > 0)      cd_ricochet -= game_speed; 
if (cd_unrelenting > 0)   cd_unrelenting -= game_speed;
if (cd_blade_toss > 0)    cd_blade_toss -= game_speed;

var _spd_mult = is_phase_2 ? 1.5 : 1.0;

var _try_blade_teleport = function() {
    if (instance_exists(active_blade) && active_blade.is_active) {
        if (random(1) < 0.45) { 
            particle_spawn_spark(x, y, 20);
            x = active_blade.x;
            y = active_blade.y;
            
            particle_spawn_ring_wave(x, y);
            particle_spawn_spark(x, y, 20);
            
            instance_destroy(active_blade);
            active_blade = noone;
            squash_timer = squash_duration; 
            
            state = SunderState.RAZORWIND_SPIN;
            state_timer = 0;
        }
    }
};

switch (state) {
    case SunderState.IDLE:
        state_timer += game_speed;
        var _delay = is_phase_2 ? 22 : idle_delay;
        
        if (state_timer >= _delay) {
            state_timer = 0;
            var _attack_choice = SunderState.CLEAVE_WINDUP;
            
            if (is_phase_2) {
                if (cd_unrelenting <= 0 && random(1) < 0.35) _attack_choice = SunderState.UNRELENTING_CHARGE;
                else if (cd_blade_toss <= 0 && !instance_exists(active_blade) && random(1) < 0.4) _attack_choice = SunderState.BLADE_TOSS;
                else if (cd_ricochet <= 0 && random(1) < 0.4) _attack_choice = SunderState.RICOCHET_ASSAULT;
                else if (cd_razorwind <= 0 && random(1) < 0.5) _attack_choice = SunderState.RAZORWIND_SPIN;
                else if (cd_quick_slashes <= 0 && random(1) < 0.6) _attack_choice = SunderState.QUICK_SLASHES;
            } else {
                if (cd_razorwind <= 0 && random(1) < 0.45) _attack_choice = SunderState.RAZORWIND_SPIN;
                else if (cd_quick_slashes <= 0 && random(1) < 0.5) _attack_choice = SunderState.QUICK_SLASHES;
            }
            
            next_attack_state = _attack_choice;
            dashes_remaining = irandom_range(1, 4);
            state = SunderState.PRE_DASH;
            dash_timer = 0; 
        }
        break;

    case SunderState.PRE_DASH:
        if (dash_timer <= 0) {
            if (dashes_remaining > 0) {
                var _offset_dist = random_range(60, 150);
                var _offset_dir = random(360);
                dash_target_x = clamp(_p_x + lengthdir_x(_offset_dist, _offset_dir), 50, room_width - 50);
                dash_target_y = clamp(_p_y + lengthdir_y(_offset_dist, _offset_dir), 50, room_height - 50);
                
                dash_dir = point_direction(x, y, dash_target_x, dash_target_y);
                var _dist = point_distance(x, y, dash_target_x, dash_target_y);
                
                dash_time_total = max(8, 12 / _spd_mult); 
                dash_speed = _dist / dash_time_total;
                dash_timer = dash_time_total;
                
                dashes_remaining -= 1;
            } else {
                state = next_attack_state;
                state_timer = 0;
                _try_blade_teleport();
            }
        } else {
            var _next_x = x + lengthdir_x(dash_speed * game_speed, dash_dir);
            var _next_y = y + lengthdir_y(dash_speed * game_speed, dash_dir);
            
            if (!place_meeting(_next_x, y, obj_wall)) x = _next_x;
            if (!place_meeting(x, _next_y, obj_wall)) y = _next_y;
            
            particle_spawn_dash_trail(x, y);
            dash_timer -= game_speed;
            
            if (dash_timer <= 0 && dashes_remaining > 0) {
                dash_timer = -5; 
            }
        }
        break;

    case SunderState.CLEAVE_WINDUP:
        state_timer += game_speed * _spd_mult;
        telegraph_angle = point_direction(x, y, _p_x, _p_y);
        telegraph_alpha = min(1, state_timer / 20);
        
        var _nx = x + lengthdir_x(1.5 * game_speed * _spd_mult, telegraph_angle);
        var _ny = y + lengthdir_y(1.5 * game_speed * _spd_mult, telegraph_angle);
        if (!place_meeting(_nx, y, obj_wall)) x = _nx;
        if (!place_meeting(x, _ny, obj_wall)) y = _ny;
        
        if (state_timer >= 28) {
            state = SunderState.CLEAVE_ATTACK;
            state_timer = 0;
            telegraph_alpha = 0;
        }
        break;

    case SunderState.CLEAVE_ATTACK:
        var _slash_dir = point_direction(x, y, _p_x, _p_y);
        var _slash = instance_create_depth(x + lengthdir_x(20, _slash_dir), y + lengthdir_y(20, _slash_dir), depth - 10, obj_sunder_slash_fx);
        _slash.image_angle = _slash_dir;
        _slash.owner_id = id;
        _slash.damage = is_phase_2 ? 8 : 6;
        _slash.is_screen_split = false;
        
        particle_spawn_slash(x, y, _slash_dir, 15);
        
        state = SunderState.IDLE;
        state_timer = 0;
        break;

    case SunderState.QUICK_SLASHES:
        if (state_timer == 0) {
            quick_slash_count = irandom_range(2, 4);
            quick_slash_phase = 0; 
            quick_slash_timer = 0;
            cd_quick_slashes = CD_QUICK_SLASHES_MAX;
        }
        
        state_timer += game_speed;
        
        if (quick_slash_count > 0) {
            quick_slash_timer += game_speed * _spd_mult;
            
            if (quick_slash_phase == 0) {
                if (quick_slash_timer % 10 < 5) image_blend = c_red;
                else image_blend = c_white;
                
                if (quick_slash_timer >= 15) {
                    quick_slash_phase = 1; 
                    quick_slash_timer = 0;
                    image_blend = c_white; 
                    
                    dash_dir = point_direction(x, y, _p_x, _p_y);
                    dash_speed = 18; 
                }
            } else if (quick_slash_phase == 1) {
                var _nx = x + lengthdir_x(dash_speed * game_speed, dash_dir);
                var _ny = y + lengthdir_y(dash_speed * game_speed, dash_dir);
                
                if (!place_meeting(_nx, y, obj_wall)) x = _nx;
                if (!place_meeting(x, _ny, obj_wall)) y = _ny;
                particle_spawn_dash_trail(x, y);
                
                if (quick_slash_timer >= 6) {
                    quick_slash_phase = 2;
                    quick_slash_timer = 0;
                    
                    var _slash = instance_create_depth(x + lengthdir_x(15, dash_dir), y + lengthdir_y(15, dash_dir), depth - 10, obj_sunder_slash_fx);
                    _slash.image_angle = dash_dir;
                    _slash.owner_id = id;
                    _slash.damage = 5;
                    _slash.is_screen_split = false;
                    
                    particle_spawn_slash(x, y, dash_dir, 8);
                }
            } else if (quick_slash_phase == 2) {
                if (quick_slash_timer >= 8) {
                    quick_slash_count -= 1;
                    quick_slash_phase = 0;
                    quick_slash_timer = 0;
                }
            }
        } else {
            image_blend = c_white;
            state = SunderState.IDLE;
            state_timer = 0;
        }
        break;
        
    case SunderState.RAZORWIND_SPIN:
        state_timer += game_speed;
        visual_angle += 25 * game_speed; 
        particle_spawn_dash_trail(x, y);
        
        if (state_timer == 1) cd_razorwind = CD_RAZORWIND_MAX;
        
        if (state_timer >= 24) {
            state = SunderState.RAZORWIND_SLASH;
            state_timer = 0;
        }
        break;

    case SunderState.RAZORWIND_SLASH:
        var _dir = point_direction(x, y, _p_x, _p_y);
        
        var _proj = instance_create_depth(x + lengthdir_x(25, _dir), y + lengthdir_y(25, _dir), depth - 5, obj_sunder_razorwind);
        _proj.direction = _dir;
        _proj.speed = 10;
        _proj.owner_id = id;
        _proj.is_enhanced = is_phase_2; 
        
        particle_spawn_slash(x, y, _dir, 15);
        
        state = SunderState.IDLE;
        state_timer = 0;
        break;

    case SunderState.RICOCHET_ASSAULT:
        if (state_timer == 0) {
            cd_ricochet = CD_VOID_STEP_MAX; 
            ricochet_bounces = 3;
            ricochet_dir = choose(45, 135, 225, 315) + random_range(-15, 15);
            ricochet_speed = 22 * _spd_mult;
            image_blend = c_fuchsia; 
        }
        
        state_timer += game_speed;
        
        var _vx = lengthdir_x(ricochet_speed * game_speed, ricochet_dir);
        var _vy = lengthdir_y(ricochet_speed * game_speed, ricochet_dir);
        var _bounced = false;

        if (place_meeting(x + _vx, y, obj_wall)) {
            _vx = -_vx;
            _bounced = true;
        } else {
            x += _vx;
        }

        if (place_meeting(x, y + _vy, obj_wall)) {
            _vy = -_vy;
            _bounced = true;
        } else {
            y += _vy;
        }

        if (_bounced) {
            ricochet_dir = point_direction(0, 0, _vx, _vy);
            ricochet_bounces -= 1;
            
            particle_spawn_shatter(x, y, 8); 
            particle_spawn_spark(x, y, 15);
            
            squash_timer = squash_duration;
        }
        
        particle_spawn_dash_trail(x, y);
        visual_angle = ricochet_dir;
        
        if (ricochet_bounces <= 0) {
            state = SunderState.RICOCHET_STRIKE;
            state_timer = 0;
            image_blend = c_white; 
        }
        break;

    case SunderState.RICOCHET_STRIKE:
        if (state_timer == 0) {
            telegraph_angle = point_direction(x, y, _p_x, _p_y); 
        }
        
        state_timer += game_speed;
        
        if (state_timer < 15) {
            visual_angle = telegraph_angle;
            particle_spawn_spark(x, y, 2); 
        } else if (state_timer == 15) {
            dash_dir = telegraph_angle;
            dash_speed = 40 * _spd_mult; 
        } else if (state_timer > 15 && state_timer < 25) {
            // Replaced collision-halting logic with straight coordinate addition to dash through walls
            x += lengthdir_x(dash_speed * game_speed, dash_dir);
            y += lengthdir_y(dash_speed * game_speed, dash_dir);
            
            particle_spawn_dash_trail(x, y);
            
            if (_player_exists && collision_circle(x, y, 25, obj_player, true, false)) {
                if (obj_player.invuln_timer <= 0) {
                    obj_player.hp -= 15; 
                    obj_player.flash_timer = 20;
                    obj_player.invuln_timer = 60;
                    
                    particle_spawn_ring_wave(_p_x, _p_y);
                    particle_spawn_shatter(_p_x, _p_y, 15);
                    
                    var _slash = instance_create_depth(_p_x, _p_y, depth - 10, obj_sunder_slash_fx);
                    _slash.image_angle = dash_dir + 90;
                    _slash.owner_id = id;
                    _slash.is_screen_split = false;
                }
            }
        } else if (state_timer >= 25) {
            state = SunderState.IDLE;
            state_timer = 0;
        }
        break;

    case SunderState.UNRELENTING_CHARGE:
        if (state_timer == 0) {
            cd_unrelenting = CD_UNRELENTING_MAX;
            unrelenting_dir = point_direction(x, y, _p_x, _p_y);
            var _line_dist = 25 * 15;
            unrelenting_line_x = x + lengthdir_x(_line_dist, unrelenting_dir);
            unrelenting_line_y = y + lengthdir_y(_line_dist, unrelenting_dir);
            unrelenting_line_alpha = 0;
        }
        
        state_timer += game_speed;
        unrelenting_line_alpha = min(1, state_timer / 12); 
        
        // Accelerated from 25 to 12 frames
        var _shake = (state_timer / 12) * 4; 
        x += random_range(-_shake, _shake);
        y += random_range(-_shake, _shake);
        image_blend = merge_color(c_white, c_red, state_timer / 12); 
        
        particle_spawn_spark(x + random_range(-15, 15), y + random_range(-15, 15), 1);
        
        if (state_timer >= 12) {
            state = SunderState.UNRELENTING_DASH;
            state_timer = 0;
            unrelenting_line_alpha = 0;
            image_blend = c_white; 
        }
        break;

    case SunderState.UNRELENTING_DASH:
        state_timer += game_speed;
        
        visual_angle = unrelenting_dir; 
        
        var _step_dist = 25 * game_speed;
        var _next_x = x + lengthdir_x(_step_dist, unrelenting_dir);
        var _next_y = y + lengthdir_y(_step_dist, unrelenting_dir);
        
        if (_player_exists && collision_line(x, y, _next_x, _next_y, obj_player, true, false)) {
            if (obj_player.invuln_timer <= 0) {
                obj_player.hp -= 20;
                obj_player.flash_timer = 20;
                obj_player.invuln_timer = 60;
                obj_player.hp_delay_timer = 20;
                
                particle_spawn_ring_wave(_p_x, _p_y);
                particle_spawn_shatter(_p_x, _p_y, 25);
                
                var _split = instance_create_depth(_p_x, _p_y, depth - 20, obj_sunder_slash_fx);
                _split.is_screen_split = true;
                _split.image_angle = unrelenting_dir + 90;
            }
        }
        
        particle_spawn_dash_trail(x, y);
        
        if (place_meeting(_next_x, y, obj_wall) || place_meeting(x, _next_y, obj_wall)) {
            state = SunderState.IDLE;
            state_timer = 0;
            squash_timer = squash_duration;
            
            particle_spawn_ring_wave(x, y);
            particle_spawn_shatter(x, y, 15);
        } else {
            x = _next_x;
            y = _next_y;
        }
        break;

    case SunderState.BLADE_TOSS:
        state_timer += game_speed;
        if (state_timer == 1) {
            cd_blade_toss = CD_BLADE_TOSS_MAX;
            var _toss_dir = point_direction(x, y, _p_x, _p_y);
            
            active_blade = instance_create_depth(x, y, depth - 2, obj_sunder_blade);
            active_blade.direction = _toss_dir;
            active_blade.target_x = _p_x;
            active_blade.target_y = _p_y;
            active_blade.owner_id = id;
        }
        
        if (state_timer >= 15) {
            state = SunderState.IDLE;
            state_timer = 0;
        }
        break;

    case SunderState.PHASE_TRANSITION:
    
        if (!balls2){
            textbox_say(["You think I'm done with you?","I will never kneel to a puppet."], c_maroon, true, 120, spr_sunder_icon);
        }
    
        state_timer += game_speed;
        var _trans_max = 60; 
        
        var _shake = (state_timer / _trans_max) * 6; 
        x += random_range(-_shake, _shake);
        y += random_range(-_shake, _shake);
        
        image_blend = merge_color(c_white, c_orange, state_timer / _trans_max);
        
        if (state_timer % 4 == 0) {
            particle_spawn_spark(x + random_range(-50, 50), y + random_range(-50, 50), 1);
        }

        if (state_timer >= _trans_max) {
            is_phase_2 = true;
            state = SunderState.IDLE;
            state_timer = 0;
            image_blend = c_white;
            
            squash_timer = squash_duration;
            particle_spawn_ring_wave(x, y);
            particle_spawn_shatter(x, y, 35);
            particle_spawn_spark(x, y, 40);
        }
        break;
}

current_move_speed = 0;
if (state == SunderState.PRE_DASH && dash_timer > 0) current_move_speed = dash_speed;
else if (state == SunderState.QUICK_SLASHES && quick_slash_phase == 1) current_move_speed = dash_speed;
else if (state == SunderState.UNRELENTING_DASH) current_move_speed = 25;
else if (state == SunderState.RICOCHET_ASSAULT) current_move_speed = ricochet_speed; 
else if (state == SunderState.RICOCHET_STRIKE && state_timer > 15) current_move_speed = dash_speed; 

var _speed_ratio = clamp(current_move_speed / 25, 0, 1);

if (squash_timer > 0) {
    squash_timer -= game_speed;
    var _sq_ratio = squash_timer / squash_duration;

    visual_scale_x = base_xscale + (squash_amount * _sq_ratio);
    visual_scale_y = base_yscale - (squash_amount * _sq_ratio);
} else {
    visual_scale_x = lerp(visual_scale_x, base_xscale + (stretch_amount * _speed_ratio), 0.3);
    visual_scale_y = lerp(visual_scale_y, base_yscale - (stretch_amount * _speed_ratio), 0.3);
}