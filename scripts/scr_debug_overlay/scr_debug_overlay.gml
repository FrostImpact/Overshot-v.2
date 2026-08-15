function debug_get_all_rooms() {
    var _rooms = [];
    var _curr = room_first;
    
    while (_curr != -1) {
        if (room_exists(_curr)) {
            array_push(_rooms, {
                id: _curr,
                name: room_get_name(_curr)
            });
        }
        _curr = room_next(_curr);
    }
    
    return _rooms;
}