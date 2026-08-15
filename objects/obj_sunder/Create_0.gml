event_inherited();

enemy_max_hp = 500;
enemy_hp = enemy_max_hp;

enemy_hp_display = enemy_hp;

damage_scale = 0.5; 

state = SunderState.IDLE;
is_phase_2 = false;
state_timer = 0;
idle_delay = 40;

cd_quick_slashes = 0; 
cd_razorwind     = 0; 
cd_ricochet      = 0; 
cd_unrelenting   = 0; 
cd_blade_toss    = 0; 

CD_QUICK_SLASHES_MAX = 8 * 60;
CD_RAZORWIND_MAX     = 8 * 60;
CD_RICOCHET_MAX      = 8 * 60;
CD_VOID_STEP_MAX     = CD_RICOCHET_MAX; 
CD_UNRELENTING_MAX   = 20 * 60;
CD_BLADE_TOSS_MAX    = 20 * 60;

dashes_remaining = 0;
dash_target_x = x;
dash_target_y = y;
dash_timer = 0;
dash_speed = 0;
dash_dir = 0;
dash_time_total = 0;
next_attack_state = SunderState.CLEAVE_WINDUP;

quick_slash_count = 0;
quick_slash_timer = 0;
quick_slash_phase = 0;

ricochet_bounces = 0;
ricochet_dir = 0;
ricochet_speed = 0;

unrelenting_dir = 0;
unrelenting_line_x = x;
unrelenting_line_y = y;
unrelenting_line_alpha = 0;

active_blade = noone;

base_xscale = 1;
base_yscale = 1;
visual_scale_x = base_xscale;
visual_scale_y = base_yscale;
visual_angle = 0;

squash_timer = 0;
squash_duration = 10;
squash_amount = 0.4;
stretch_amount = 0.3;
current_move_speed = 0; 

telegraph_alpha = 0;
telegraph_angle = 0;

balls = false
balls2 = false

particle_init();