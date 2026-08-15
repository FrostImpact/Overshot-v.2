var _is_level_done = (variable_global_exists("level_completed") && global.level_completed);

if (game_state_is_paused() && !_is_level_done) {
    
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    
    draw_set_color(c_black);
    draw_set_alpha(0.65);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    
    draw_set_alpha(1.0);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    draw_text_transformed(_gui_w / 2, (_gui_h / 2) - 20, "PAUSED", 2.5, 2.5, 0);
    draw_text(_gui_w / 2, (_gui_h / 2) + 40, "Press ESC to Resume");
	
	draw_set_color(c_white);
    draw_rectangle(10, 10, 150, 60, false);
    draw_set_color(c_black);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(80, 35, "Main Menu");
    draw_set_color(c_white);
}