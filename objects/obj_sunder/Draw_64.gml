if (!is_dead) {
    var _gui_w = display_get_gui_width();
    
    var _bar_w = 500; 
    var _bar_h = 16; 
    var _bar_x = (_gui_w - _bar_w) / 2; 
    var _bar_y = 40;  
    
    // Calculate pixel widths for actual and display (delayed) health
    var _width_display = _bar_w * clamp(enemy_hp_display / enemy_max_hp, 0, 1);
    var _width_actual  = _bar_w * clamp(enemy_hp / enemy_max_hp, 0, 1);

    // Drop shadow
    draw_set_color(c_black);
    draw_set_alpha(0.8);
    draw_rectangle(_bar_x + 4, _bar_y + 4, _bar_x + _bar_w + 4, _bar_y + _bar_h + 4, false);

    // Background bar
    draw_set_color(make_color_rgb(40, 10, 10));
    draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + _bar_h, false);

    // 1. Trailing/Delayed Health Bar (renders behind actual health)
    if (_width_display > 0) {
        draw_set_color(c_white);
        draw_set_alpha(0.85);
        draw_rectangle(_bar_x, _bar_y, _bar_x + _width_display, _bar_y + _bar_h, false);
    }

    // 2. Actual Health Bar (Phase 1 Red / Phase 2 Orange)
    if (_width_actual > 0) {
        draw_set_color(is_phase_2 ? c_orange : make_color_rgb(220, 20, 60));
        draw_set_alpha(1.0);
        draw_rectangle(_bar_x, _bar_y, _bar_x + _width_actual, _bar_y + _bar_h, false);

        // Top edge highlight sheen
        draw_set_color(c_white);
        draw_set_alpha(0.25);
        draw_rectangle(_bar_x, _bar_y, _bar_x + _width_actual, _bar_y + max(1, _bar_h * 0.25), false);
    }

    // Health bar outline
    draw_set_color(c_white);
    draw_set_alpha(0.15);
    draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + _bar_h, true);

    // Phase 2 threshold indicator line (50% mark)
    var _p2_x = _bar_x + (_bar_w * 0.50);
    draw_set_color(c_white);
    draw_set_alpha(1.0);
    draw_line_width(_p2_x, _bar_y - 4, _p2_x, _bar_y + _bar_h + 4, 2);

    // Boss Name Text
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    
    var _boss_name = is_phase_2 ? "SUNDER (ENRAGED)" : "SUNDER, THE UNRELENTING";
    
    // Text shadow
    draw_set_color(c_black);
    draw_text(_gui_w / 2 + 1, _bar_y - 1 + 1, _boss_name);
    
    // Main text
    draw_set_color(is_phase_2 ? c_orange : c_white);
    draw_text(_gui_w / 2, _bar_y - 1, _boss_name);

    // Reset draw state safely
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}