function check_collision_array(check_x, check_y, obj_array) {
    for (var i = 0; i < array_length(obj_array); i++) {
        if (place_meeting(check_x, check_y, obj_array[i])) {
            return obj_array[i]
        }
    }
    return noone
}

function physics_unstick(inst, solid_objects, max_radius) {
    with (inst) {
        if (check_collision_array(x, y, solid_objects) != noone) {
            for (var r = 1; r <= max_radius; r++) {
                for (var angle = 0; angle < 360; angle += 45) {
                    var test_x = x + lengthdir_x(r, angle)
                    var test_y = y + lengthdir_y(r, angle)
                    if (check_collision_array(test_x, test_y, solid_objects) == noone) {
                        x = test_x
                        y = test_y
                        return true
                    }
                }
            }
        }
    }
    return false
}

function physics_resolve_axis(inst, axis, move_amount, solid_objects, hurt_objects, bounce_factor) {
    if (move_amount == 0) return

    var _sign = sign(move_amount)

    with (inst) {
        if (axis == "x") {
            if (check_collision_array(x + move_amount, y, solid_objects) != noone) {
                if (_sign != 0 && check_collision_array(x, y, solid_objects) == noone) {
                    while (check_collision_array(x + _sign, y, solid_objects) == noone) {
                        x += _sign
                    }
                }

                impact_speed = abs(xspeed)
                xspeed = -xspeed * bounce_factor

                if (check_collision_array(x + _sign, y, hurt_objects) != noone) {
                    hp -= 10
                }

                if (impact_speed > 1) {
                    squash_timer = squash_duration * game_state_get_speed()
                }
            } else {
                x += move_amount
            }
        } else if (axis == "y") {
            if (check_collision_array(x, y + move_amount, solid_objects) != noone) {
                if (_sign != 0 && check_collision_array(x, y, solid_objects) == noone) {
                    while (check_collision_array(x, y + _sign, solid_objects) == noone) {
                        y += _sign
                    }
                }

                impact_speed = abs(yspeed)

                if (check_collision_array(x, y + _sign, hurt_objects) != noone) {
                    hp -= 10
                }

                if (_sign > 0) {
                    yspeed = -abs(yspeed) * bounce_factor // Bounce upward off floor
                } else if (_sign < 0) {
                    yspeed = abs(yspeed) * bounce_factor // Bounce downward off ceiling
                }

                if (impact_speed > 1) {
                    squash_timer = squash_duration * game_state_get_speed()
                }
            } else {
                y += move_amount
            }
        }
    }
}