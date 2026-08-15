function launch_compute_velocity(drag_x, drag_y, power_scale, max_speed) {
	
    var _dist = point_distance(0, 0, drag_x, drag_y)
    var _launch_speed = min(_dist * power_scale * 0.2, max_speed)
    var _dir = point_direction(0, 0, drag_x, drag_y)

    return {
        hspd: lengthdir_x(_launch_speed, _dir),
        vspd: lengthdir_y(_launch_speed, _dir)
    }
}