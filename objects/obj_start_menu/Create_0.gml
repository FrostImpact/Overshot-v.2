hover_amt = 0;
time = 0; 

intro_timer = 0;
anim_banner_width = 0;        
anim_text_offset = 3000;     
anim_btn_scale = 0;          

bg_particles = [];
for (var i = 0; i < 100; i++) {
    array_push(bg_particles, {
        x: random(room_width),
        y: random(room_height),
        size: random_range(5, 15),
        spd: random_range(0.2, 0.8),
        rot: random(360),
        rot_spd: random_range(-1, 1)
    });
}

