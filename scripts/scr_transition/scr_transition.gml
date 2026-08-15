/// @function transition_to_room(_room)
/// @param {Asset.GMRoom} _room The room to transition to.
function transition_to_room(_room) {
    if (instance_exists(obj_transition_manager)) {
        with (obj_transition_manager) {
            if (state == TransitionState.NONE) {
                
                var _surf = application_surface;
                snapshot_sprite = sprite_create_from_surface(_surf, 0, 0, surface_get_width(_surf), surface_get_height(_surf), false, false, 0, 0);

                state = TransitionState.SLIDING;
                progress = 0;

                room_goto(_room); 
            }
        }
    } else {
        room_goto(_room);
    }
}