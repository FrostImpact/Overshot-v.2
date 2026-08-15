function player_trigger_death() {
    is_dead = true;
    death_timer = 0;
    
    visible = false;
    
    xspeed = 0;
    yspeed = 0;
    
    var _num_pieces = 24; 
    for (var i = 0; i < _num_pieces; i++) {
        var _piece = instance_create_layer(x, y, layer, obj_player_piece);
        
        _piece.direction = (360 / _num_pieces) * i + random_range(-15, 15);
        _piece.speed = random_range(6, 14); 
        
        _piece.friction = _piece.speed / 30; 
        
        _piece.target_x = xstart;
        _piece.target_y = ystart;
    }
}

function player_death_step() {
    death_timer++;
    
    if (death_timer >= 100) {
        room_restart();
    }
}