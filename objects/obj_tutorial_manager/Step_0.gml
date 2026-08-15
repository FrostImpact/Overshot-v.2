if (delay_timer > 0) {
    delay_timer--;
    exit;
}

switch (tutorial_step) {
    case 0:
        textbox_say(["Welcome to Overshoot!", "A game about... launching balls... at other balls", "Try dragging your mouse to aim!"], c_red, true, 120, spr_narrator);
        tutorial_step++;
        break;
        
    case 1:
        if (obj_player.aim_check == true) {
            textbox_say(["Notice how time slows down while aiming?", "Release to launch!"], c_red, true, 120,  spr_narrator);
            tutorial_step++;
        }
        break;
        
    case 2:
        if (obj_player.aim_check == false) {
            textbox_say(["Perfect!", "Ugh, another one of those dirty red balls...", "Take care of it for me."], c_red, true, 120,  spr_narrator);
            tutorial_step++;
        }
        break;
}