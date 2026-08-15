

if (state == TransitionState.SLIDING) {
    progress += transition_speed;
    
    if (progress >= 1) {
        progress = 0;
        state = TransitionState.NONE;
        
        if (sprite_exists(snapshot_sprite)) {
            sprite_delete(snapshot_sprite);
            snapshot_sprite = -1;
        }
    }
}