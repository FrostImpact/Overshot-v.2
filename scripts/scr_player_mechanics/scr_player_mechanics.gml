function player_take_damage(amount, knockback_angle) {
    with (obj_player) {

        if (hp <= 0 || invuln_timer > 0) return false;

        hp -= amount;
        
        var _knockback_force = 15; 
        xspeed = lengthdir_x(_knockback_force, knockback_angle);
        yspeed = lengthdir_y(_knockback_force, knockback_angle) - 4;
        
        invuln_timer = 60; 
        flash_timer = 12;  
        hp_delay_timer = 30; 
       
        game_state_set_hitstop(20, 0.1); 
        
        return true;
    }
    return false;
}