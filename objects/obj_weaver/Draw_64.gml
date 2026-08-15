if (!is_dead) {
    var _gui_w = display_get_gui_width();
    
    var _bar_w = 500; 
    var _bar_h = 16; 
    var _bar_x = (_gui_w - _bar_w) / 2; 
    var _bar_y = 40;  
    
    var _width_display = _bar_w * clamp(enemy_hp_display / enemy_max_hp, 0, 1);
    var _width_actual  = _bar_w * clamp(enemy_hp / enemy_max_hp, 0, 1);

    // Drop shadow (Black is retained just for UI depth)
    draw_set_color(c_black);
    draw_set_alpha(0.8);
    draw_rectangle(_bar_x + 4, _bar_y + 4, _bar_x + _bar_w + 4, _bar_y + _bar_h + 4, false);

    // Background bar (Dark Abyss Purple)
    draw_set_color(color_dark);
    draw_set_alpha(1.0);
    draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + _bar_h, false);

    // Delayed display health bar (Pale Lavender)
    if (_width_display > 0) {
        draw_set_color(color_light);
        draw_set_alpha(0.85);
        draw_rectangle(_bar_x, _bar_y, _bar_x + _width_display, _bar_y + _bar_h, false);
    }

    // Actual Health Bar (Amethyst / Violet)
    if (_width_actual > 0) {
        draw_set_color(is_phase_2 ? color_p2 : color_p1);
        draw_set_alpha(1.0);
        draw_rectangle(_bar_x, _bar_y, _bar_x + _width_actual, _bar_y + _bar_h, false);

        // Sheen (Replaced White with Lavender)
        draw_set_color(color_light);
        draw_set_alpha(0.25);
        draw_rectangle(_bar_x, _bar_y, _bar_x + _width_actual, _bar_y + max(1, _bar_h * 0.25), false);
    }

    // Outline (Lavender)
    draw_set_color(color_light);
    draw_set_alpha(0.2);
    draw_rectangle(_bar_x, _bar_y, _bar_x + _bar_w, _bar_y + _bar_h, true);

    // Phase 2 threshold indicator line (60% mark)
    var _p2_x = _bar_x + (_bar_w * 0.60);
    draw_set_color(color_light);
    draw_set_alpha(1.0);
    draw_line_width(_p2_x, _bar_y - 3, _p2_x, _bar_y + _bar_h + 3, 2);

    // Title (Lavender)
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(color_light);
    draw_set_alpha(0.9);
    draw_text(_gui_w / 2, _bar_y - 6, "WEAVER, PERFECTION INCARNATE");

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1.0);
}