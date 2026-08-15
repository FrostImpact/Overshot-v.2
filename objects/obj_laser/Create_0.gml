event_inherited()

tracking_duration = 90
lock_duration = 30
fire_duration = 15

laser_angle = 0
laser_track_rate = 0.2
laser_state = LaserState.TRACKING
laser_timer = random_range(0, tracking_duration)

laser_damage = 10
has_hit_player = false

kick_timer = 0
kick_duration = 10
kick_amount = 0.3