if (game_state_is_paused()) exit;

var game_speed = game_state_get_speed();
spin_angle += 20 * game_speed;

if (point_distance(x, y, target_x, target_y) > 8) {
    x = lerp(x, target_x, 0.2 * game_speed);
    y = lerp(y, target_y, 0.2 * game_speed);
}

duration -= game_speed;
if (duration <= 0) {
    instance_destroy();
}