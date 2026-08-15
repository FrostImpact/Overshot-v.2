timer++;

if (phase == 0) {

    if (speed <= 0.1) {
        speed = 0; 
        phase = 1;

        timer = 30; 
    }
} else if (phase == 1) {

    if (timer > 50) {
        phase = 2;
    }
} else if (phase == 2) {

    x = lerp(x, target_x, 0.1);
    y = lerp(y, target_y, 0.1);
    
    image_alpha = lerp(image_alpha, 0.5, 0.05);
}