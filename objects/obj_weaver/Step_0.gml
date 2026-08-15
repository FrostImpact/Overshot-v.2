if (game_state_is_paused()) exit;

enemy_hp_display = lerp(enemy_hp_display, enemy_hp, 0.1);

var game_speed = game_state_get_speed();

if (is_dead) {
    visual_scale_x += 0.05 * game_speed;
    visual_scale_y += 0.05 * game_speed;
    image_alpha  -= 0.03 * game_speed;
    if (image_alpha <= 0) instance_destroy();
    exit;
}

event_inherited();

var _player_exists = instance_exists(obj_player);
var _p_x = _player_exists ? obj_player.x : x;
var _p_y = _player_exists ? obj_player.y : y;

if (_player_exists && state != WeaverState.DASH && state != WeaverState.PHASE_TRANSITION) {
    visual_angle = point_direction(x, y, _p_x, _p_y);
    image_angle = visual_angle;
}

var _hp_ratio = enemy_hp / enemy_max_hp;
if (!is_phase_2 && _hp_ratio <= 0.60 && state != WeaverState.PHASE_TRANSITION) {
    state = WeaverState.PHASE_TRANSITION;
    state_timer = 0;
    dash_timer = 0;
}

if (cd_pinpoint > 0) cd_pinpoint -= game_speed;
if (cd_drill > 0)    cd_drill    -= game_speed;
if (cd_dash > 0)     cd_dash     -= game_speed;
if (cd_wall > 0)     cd_wall     -= game_speed;

var _spd_mult = is_phase_2 ? 1.1 : 1.0;

// --- PASSIVE: SILK ECHOES ---
if (_player_exists && state != WeaverState.PHASE_TRANSITION) {
    passive_timer += game_speed * _spd_mult;
    var _interval = is_phase_2 ? passive_interval_p2 : passive_interval_p1;
    
    if (passive_timer >= _interval) {
        passive_timer = 0;
        array_push(silk_echoes, {
            x: _p_x, y: _p_y, timer: 100, max_timer: 100
        });
    }
}

var _fire_broad_needles = function(_center_dir) {
    var _spread_angles = [-22, 0, 22];
    for (var _i = 0; _i < 3; _i++) {
        var _n_dir = _center_dir + _spread_angles[_i];
        array_push(needles, {
            x: x + lengthdir_x(20, _n_dir), y: y + lengthdir_y(20, _n_dir),
            dir: _n_dir, spd: 15, damage: 6
        });
        particle_spawn_needle_burst(x, y, _n_dir, 6);
    }
    particle_spawn_ring_wave(x, y);
};

for (var _i = array_length(echo_trail) - 1; _i >= 0; _i--) {
    var _e = echo_trail[_i];
    _e.alpha -= 0.04 * game_speed;
    if (_e.alpha <= 0) array_delete(echo_trail, _i, 1);
}

// =====================================================================
// BOSS STATE MACHINE
// =====================================================================
switch (state) {
    case WeaverState.IDLE:
        state_timer += game_speed;
        var _delay = is_phase_2 ? 18 : idle_delay;

        if (state_timer >= _delay) {
            state_timer = 0;
            var _available_attacks = [];
            if (cd_pinpoint <= 0) array_push(_available_attacks, WeaverAttackType.PINPOINT_NEEDLES);
            if (cd_drill <= 0)    array_push(_available_attacks, WeaverAttackType.CONE_DRILL);
            if (cd_dash <= 0)     array_push(_available_attacks, WeaverAttackType.DASH);
            if (is_phase_2 && cd_wall <= 0) array_push(_available_attacks, WeaverAttackType.WEAVER_WALL);

            next_attack_type = (array_length(_available_attacks) == 0) ? WeaverAttackType.PINPOINT_NEEDLES : _available_attacks[irandom(array_length(_available_attacks) - 1)];

            state = WeaverState.PRE_ATTACK;
            telegraph_dir = point_direction(x, y, _p_x, _p_y);
            telegraph_alpha = 0;
            attack_timer = 0;
        }
        break;

    case WeaverState.PRE_ATTACK:
        attack_timer += game_speed * _spd_mult;
        telegraph_dir = point_direction(x, y, _p_x, _p_y);
        telegraph_alpha = min(1.0, attack_timer / 15);

        if (attack_timer >= 18) {
            telegraph_alpha = 0;
            attack_timer = 0;
            
            switch (next_attack_type) {
                case WeaverAttackType.PINPOINT_NEEDLES:
                    state = WeaverState.PINPOINT_NEEDLES;
                    cd_pinpoint = CD_PINPOINT_MAX;
                    needles_fired_count = 0;
                    break;
                case WeaverAttackType.CONE_DRILL:
                    state = WeaverState.CONE_DRILL;
                    cd_drill = CD_DRILL_MAX;
                    break;
                case WeaverAttackType.DASH:
                    state = WeaverState.DASH;
                    cd_dash = is_phase_2 ? CD_DASH_MAX_P2 : CD_DASH_MAX_P1;
                    
                    var _dist_to_p = point_distance(x, y, _p_x, _p_y);
                    var _base_dir = point_direction(x, y, _p_x, _p_y);
                    
                    if (_dist_to_p > 280) dash_dir = _base_dir + random_range(-15, 15);
                    else if (_dist_to_p < 120) dash_dir = _base_dir + 180 + random_range(-20, 20);
                    else dash_dir = _base_dir + choose(70, -70, 90, -90) + random_range(-10, 10);
                    
                    var _range = is_phase_2 ? 300 : 220;
                    var _tx = clamp(x + lengthdir_x(_range, dash_dir), 60, room_width - 60);
                    var _ty = clamp(y + lengthdir_y(_range, dash_dir), 60, room_height - 60);
                    
                    dash_dir = point_direction(x, y, _tx, _ty);
                    var _dist = point_distance(x, y, _tx, _ty);
                    dash_time_total = max(6, _dist / (is_phase_2 ? 24 : 18));
                    dash_speed = _dist / dash_time_total;
                    dash_timer = dash_time_total;
                    break;
                case WeaverAttackType.WEAVER_WALL:
                    state = WeaverState.WEAVER_WALL;
                    cd_wall = CD_WALL_MAX;
                    break;
            }
        }
        break;

    case WeaverState.PINPOINT_NEEDLES:
        attack_timer += game_speed * _spd_mult;
        if (needles_fired_count < 3 && attack_timer >= needles_fired_count * 6) {
            var _fire_dir = point_direction(x, y, _p_x, _p_y);
            array_push(needles, {
                x: x + lengthdir_x(20, _fire_dir), y: y + lengthdir_y(20, _fire_dir),
                dir: _fire_dir, spd: 16, damage: 7
            });
            particle_spawn_needle_burst(x, y, _fire_dir, 8);
            needles_fired_count++;
        }
        if (needles_fired_count >= 3 && attack_timer >= 24) {
            if (is_phase_2) _fire_broad_needles(point_direction(x, y, _p_x, _p_y));
            state = WeaverState.IDLE;
            state_timer = 0;
        }
        break;

    case WeaverState.CONE_DRILL:
        attack_timer += game_speed;
        if (attack_timer == 1) {
            var _drill_dir = point_direction(x, y, _p_x, _p_y);
            array_push(drills, {
                x: x + lengthdir_x(25, _drill_dir), y: y + lengthdir_y(25, _drill_dir),
                dir: _drill_dir, spd: 6.0, damage: 10, radius: 24, rot: 0
            });
            particle_spawn_ring_wave(x, y);
            particle_spawn_spark(x, y, 15);
            if (is_phase_2) _fire_broad_needles(_drill_dir);
        }
        if (attack_timer >= 14) {
            state = WeaverState.IDLE;
            state_timer = 0;
        }
        break;

    case WeaverState.DASH:
        if (dash_timer > 0) {
            var _nx = x + lengthdir_x(dash_speed * game_speed, dash_dir);
            var _ny = y + lengthdir_y(dash_speed * game_speed, dash_dir);
            if (!place_meeting(_nx, y, obj_wall)) x = _nx;
            if (!place_meeting(x, _ny, obj_wall)) y = _ny;

            if (dash_timer % 2 < 1) {
                array_push(echo_trail, {
                    x: x, y: y, angle: visual_angle, scale_x: visual_scale_x, scale_y: visual_scale_y,
                    alpha: 0.65, color: is_phase_2 ? color_p2 : color_p1
                });
            }

            dash_timer -= game_speed;
            if (dash_timer <= 0) {
                if (is_phase_2) _fire_broad_needles(point_direction(x, y, _p_x, _p_y));
                state = WeaverState.IDLE;
                state_timer = 0;
            }
        }
        break;

    case WeaverState.WEAVER_WALL:
        attack_timer += game_speed;
        if (attack_timer == 1) {
            var _wall_dir = point_direction(x, y, _p_x, _p_y);
            if (array_length(weaver_walls) >= 3) {
                var _oldest = weaver_walls[0];
                particle_spawn_shatter((_oldest.x1 + _oldest.x2) / 2, (_oldest.y1 + _oldest.y2) / 2, 16);
                array_delete(weaver_walls, 0, 1);
            }

            var _max_half_len = 55;
            var _dist_pos = 0;
            var _dist_neg = 0;

            for (var _d = 0; _d <= _max_half_len; _d += 4) {
                if (position_meeting(x + lengthdir_x(_d, _wall_dir), y + lengthdir_y(_d, _wall_dir), obj_wall)) break;
                _dist_pos = _d;
            }
            for (var _d = 0; _d <= _max_half_len; _d += 4) {
                if (position_meeting(x - lengthdir_x(_d, _wall_dir), y - lengthdir_y(_d, _wall_dir), obj_wall)) break;
                _dist_neg = _d;
            }

            array_push(weaver_walls, {
                x1: x - lengthdir_x(_dist_neg, _wall_dir), y1: y - lengthdir_y(_dist_neg, _wall_dir),
                x2: x + lengthdir_x(_dist_pos, _wall_dir), y2: y + lengthdir_y(_dist_pos, _wall_dir),
                dir: _wall_dir, width: 4
            });

            particle_spawn_ring_wave(x, y);
            particle_spawn_spark(x, y, 20);
            if (is_phase_2) _fire_broad_needles(_wall_dir);
        }
        if (attack_timer >= 14) {
            state = WeaverState.IDLE;
            state_timer = 0;
        }
        break;

    case WeaverState.PHASE_TRANSITION:
        state_timer += game_speed;
        if (state_timer >= 50) {
            is_phase_2 = true;
            state = WeaverState.IDLE;
            state_timer = 0;
            squash_timer = squash_duration;
            particle_spawn_ring_wave(x, y);
            particle_spawn_shatter(x, y, 40);
        }
        break;
}

current_move_speed = (state == WeaverState.DASH && dash_timer > 0) ? dash_speed : 0;
var _speed_ratio = clamp(current_move_speed / 24, 0, 1);

if (squash_timer > 0) {
    squash_timer -= game_speed;
    var _progress = 1 - (squash_timer / squash_duration);
    visual_scale_x = base_xscale + (sin(_progress * pi) * squash_amount);
    visual_scale_y = base_yscale - (sin(_progress * pi) * squash_amount);
} else if (_speed_ratio > 0) {
    visual_scale_x = base_xscale + (_speed_ratio * stretch_amount);
    visual_scale_y = base_yscale - (_speed_ratio * stretch_amount);
} else {
    visual_scale_x = lerp(visual_scale_x, base_xscale, 0.2);
    visual_scale_y = lerp(visual_scale_y, base_yscale, 0.2);
}

// =====================================================================
// ENTITY UPDATES
// =====================================================================
for (var _i = array_length(silk_echoes) - 1; _i >= 0; _i--) {
    var _e = silk_echoes[_i];
    _e.timer -= game_speed;
    if (_e.timer <= 0) {
        for (var _a = 0; _a < 360; _a += 90) {
            array_push(needles, { x: _e.x, y: _e.y, dir: _a, spd: 13, damage: 5 });
        }
        particle_spawn_shatter(_e.x, _e.y, 10);
        array_delete(silk_echoes, _i, 1);
    }
}

for (var _i = array_length(needles) - 1; _i >= 0; _i--) {
    var _n = needles[_i];
    _n.x += lengthdir_x(_n.spd * game_speed, _n.dir);
    _n.y += lengthdir_y(_n.spd * game_speed, _n.dir);

    var _hit = false;
    if (place_meeting(_n.x, _n.y, obj_wall)) {
        particle_spawn_shatter(_n.x, _n.y, 8);
        _hit = true;
    } else if (_player_exists && point_distance(_n.x, _n.y, obj_player.x, obj_player.y) < 20) {
        with (obj_player) {
            if (variable_instance_exists(id, "take_damage")) take_damage(_n.damage);
            else if (variable_instance_exists(id, "hp")) hp -= _n.damage;
        }
        _hit = true;
    }
    if (_n.x < -50 || _n.x > room_width + 50 || _n.y < -50 || _n.y > room_height + 50) _hit = true;
    if (_hit) array_delete(needles, _i, 1);
}

for (var _i = array_length(drills) - 1; _i >= 0; _i--) {
    var _d = drills[_i];
    _d.rot += 12 * game_speed; // Rotate the geometric shards

    var _vx = lengthdir_x(_d.spd * game_speed, _d.dir);
    var _vy = lengthdir_y(_d.spd * game_speed, _d.dir);
    var _bounced = false;

    if (place_meeting(_d.x + _vx, _d.y, obj_wall)) { _vx = -_vx; _bounced = true; } else _d.x += _vx;
    if (place_meeting(_d.x, _d.y + _vy, obj_wall)) { _vy = -_vy; _bounced = true; } else _d.y += _vy;

    if (_bounced) {
        _d.dir = point_direction(0, 0, _vx, _vy);
        particle_spawn_spark(_d.x, _d.y, 10);
    }

    if (_player_exists && point_distance(_d.x, _d.y, obj_player.x, obj_player.y) < _d.radius * 0.8) {
        with (obj_player) {
            if (variable_instance_exists(id, "take_damage")) take_damage(_d.damage);
            else if (variable_instance_exists(id, "hp")) hp -= _d.damage;
        }
        particle_spawn_shatter(_d.x, _d.y, 15);
        array_delete(drills, _i, 1);
    }
}

for (var _i = array_length(weaver_walls) - 1; _i >= 0; _i--) {
    var _w = weaver_walls[_i];
    if (_player_exists) {
        if (distance_to_segment(obj_player.x, obj_player.y, _w.x1, _w.y1, _w.x2, _w.y2) < 16) {
            with (obj_player) {
                if (variable_instance_exists(id, "hsp")) hsp *= 0.1;
                if (variable_instance_exists(id, "vsp")) vsp *= 0.1;
                if (variable_instance_exists(id, "speed")) speed *= 0.1;
                if (variable_instance_exists(id, "slow_timer")) slow_timer = 90;
                else variable_instance_set(id, "slow_timer", 90);
            }
            particle_spawn_shatter((_w.x1 + _w.x2) / 2, (_w.y1 + _w.y2) / 2, 16);
            array_delete(weaver_walls, _i, 1);
        }
    }
}