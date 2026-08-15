if (game_state_is_paused()) exit;

var game_speed = game_state_get_speed();
life_timer -= game_speed;
image_alpha = life_timer / 12;


if (random(1) < 0.4) {
    particle_spawn_spark(x + random_range(-10, 10), y + random_range(-10, 10), 1);
}

if (!has_dealt_damage && !is_screen_split && instance_exists(obj_player)) {
    if (place_meeting(x, y, obj_player)) {
        if (obj_player.invuln_timer <= 0) {

			player_take_damage(damage, image_angle);

            obj_player.flash_timer = 15;
            obj_player.invuln_timer = 40;
            obj_player.hp_delay_timer = 20;
            has_dealt_damage = true;
        }
    }
}

if (life_timer <= 0) {
    instance_destroy();
}