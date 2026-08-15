event_inherited();

// Boss Attributes
enemy_max_hp = 600;
enemy_hp = enemy_max_hp;
enemy_hp_display = enemy_hp;
damage_scale = 0.5;

// Visual & Animation Variables
base_xscale = 1.0;
base_yscale = 1.0;
visual_scale_x = base_xscale;
visual_scale_y = base_yscale;
visual_angle = 0;

squash_timer = 0;
squash_duration = 12;
squash_amount = 0.35;
stretch_amount = 0.25;
current_move_speed = 0;
flash_timer = 0;

// States
enum WeaverState {
    IDLE,
    PRE_ATTACK,
    PINPOINT_NEEDLES,
    CONE_DRILL,
    DASH,
    WEAVER_WALL,
    PHASE_TRANSITION
}

enum WeaverAttackType {
    PINPOINT_NEEDLES,
    CONE_DRILL,
    DASH,
    WEAVER_WALL
}

state = WeaverState.IDLE;
is_phase_2 = false;
state_timer = 0;
idle_delay = 28;

// Cooldowns (in frames)
cd_pinpoint = 0;
cd_drill    = 0;
cd_dash     = 0;
cd_wall     = 0;

CD_PINPOINT_MAX = 3.0 * 60;
CD_DRILL_MAX    = 5.0 * 60;
CD_DASH_MAX_P1  = 3.0 * 60; 
CD_DASH_MAX_P2  = 2.0 * 60; 
CD_WALL_MAX     = 6.5 * 60;

// Sub-state & Telegraph tracking
attack_timer = 0;
needles_fired_count = 0;
next_attack_type = WeaverAttackType.PINPOINT_NEEDLES;

telegraph_dir = 0;
telegraph_alpha = 0;

// Dash Movement
dash_dir = 0;
dash_speed = 0;
dash_time_total = 0;
dash_timer = 0;

// Managed Sub-Entities
needles = [];      
drills = [];       
weaver_walls = []; 
silk_echoes = []; 
echo_trail = []; 

// Passive Timer
passive_timer = 0;
passive_interval_p1 = 210; 
passive_interval_p2 = 150; 

// DARK PURPLE PALETTE (Zero White)
color_dark  = make_color_rgb(40, 10, 70);    // Deep Abyss Purple (Shadows/BGs)
color_p1    = make_color_rgb(130, 30, 210);  // Darker Amethyst (Phase 1)
color_p2    = make_color_rgb(180, 20, 150);  // Darker Violet (Phase 2)
color_light = make_color_rgb(235, 180, 255); // Pale Lavender (Replaces ALL white)

// Geometry Helper
distance_to_segment = function(_px, _py, _x1, _y1, _x2, _y2) {
    var _dx = _x2 - _x1;
    var _dy = _y2 - _y1;
    if (_dx == 0 && _dy == 0) return point_distance(_px, _py, _x1, _y1);

    var _t = ((_px - _x1) * _dx + (_py - _y1) * _dy) / (_dx * _dx + _dy * _dy);
    _t = clamp(_t, 0, 1);

    var _closest_x = _x1 + _t * _dx;
    var _closest_y = _y1 + _t * _dy;
    return point_distance(_px, _py, _closest_x, _closest_y);
};