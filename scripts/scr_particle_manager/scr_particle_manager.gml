/// @function particle_init()
/// @description Initializes global particle system and minimalist geometric particle types.
function particle_init() {
    if (!variable_global_exists("p_sys")) {
        global.p_sys = part_system_create();
        part_system_depth(global.p_sys, -100); // Ensures particles render above gameplay elements
        
        // -------------------------------------------------------------
        // 1. DASH TRAIL (Shrinking Squares)
        // -------------------------------------------------------------
        global.p_trail = part_type_create();
        part_type_shape(global.p_trail, pt_shape_square);
        part_type_size(global.p_trail, 0.15, 0.35, -0.015, 0);
        part_type_color2(global.p_trail, c_red, c_black); 
        part_type_alpha2(global.p_trail, 0.7, 0);
        part_type_life(global.p_trail, 10, 15);

        // -------------------------------------------------------------
        // 2. SPARK / BOUNCE (Crisp Radial Lines)
        // -------------------------------------------------------------
        global.p_spark = part_type_create();
        part_type_shape(global.p_spark, pt_shape_line);
        part_type_size(global.p_spark, 0.1, 0.25, -0.01, 0);
        part_type_color2(global.p_spark, c_white, c_red);
        part_type_speed(global.p_spark, 3, 7, -0.2, 0);
        part_type_direction(global.p_spark, 0, 360, 0, 0);
        part_type_orientation(global.p_spark, 0, 360, 0, 0, true);
        part_type_life(global.p_spark, 8, 16);

        // -------------------------------------------------------------
        // 3. SLASH / DIRECTIONAL BURST (Focused Line Rays)
        // -------------------------------------------------------------
        global.p_slash = part_type_create();
        part_type_shape(global.p_slash, pt_shape_line);
        part_type_size(global.p_slash, 0.15, 0.35, -0.015, 0);
        part_type_color2(global.p_slash, c_white, c_orange);
        part_type_speed(global.p_slash, 4, 9, -0.3, 0);
        part_type_orientation(global.p_slash, 0, 360, 0, 0, true);
        part_type_life(global.p_slash, 10, 18);

        // -------------------------------------------------------------
        // 4. RING SHOCKWAVE (Expanding Ring for Launches/Impacts)
        // -------------------------------------------------------------
        global.p_ring = part_type_create();
        part_type_shape(global.p_ring, pt_shape_ring);
        part_type_size(global.p_ring, 0.05, 0.05, 0.08, 0); // Grows rapidly
        part_type_color2(global.p_ring, c_white, c_gray);
        part_type_alpha2(global.p_ring, 0.8, 0);
        part_type_life(global.p_ring, 8, 12);

        // -------------------------------------------------------------
        // 5. SHATTER / FRAGMENT (Sharp Exploding Micro-Squares)
        // -------------------------------------------------------------
        global.p_shatter = part_type_create();
        part_type_shape(global.p_shatter, pt_shape_pixel);
        part_type_size(global.p_shatter, 1.5, 3, -0.05, 0);
        part_type_color2(global.p_shatter, c_white, c_red);
        part_type_speed(global.p_shatter, 2, 6, -0.1, 0);
        part_type_direction(global.p_shatter, 0, 360, 0, 0);
        part_type_life(global.p_shatter, 12, 22);

        // -------------------------------------------------------------
        // 6. WEAVER STRING TRAIL (Minimalist Silk Thread)
        // -------------------------------------------------------------
        global.p_string = part_type_create();
        part_type_shape(global.p_string, pt_shape_pixel);
        part_type_size(global.p_string, 1.0, 2.0, -0.05, 0);
        part_type_color2(global.p_string, c_white, c_aqua);
        part_type_alpha2(global.p_string, 0.8, 0);
        part_type_life(global.p_string, 8, 14);

        // -------------------------------------------------------------
        // 7. WEAVER NEEDLE BURST (Focused Line Thrusters)
        // -------------------------------------------------------------
        global.p_needle = part_type_create();
        part_type_shape(global.p_needle, pt_shape_line);
        part_type_size(global.p_needle, 0.1, 0.3, -0.01, 0);
        part_type_color2(global.p_needle, c_white, c_fuchsia);
        part_type_speed(global.p_needle, 5, 10, -0.4, 0);
        part_type_orientation(global.p_needle, 0, 360, 0, 0, true);
        part_type_life(global.p_needle, 8, 15);
    }
}

/// @function particle_cleanup()
/// @description Memory management: destroys particle types and system on game end/room change.
function particle_cleanup() {
    if (variable_global_exists("p_sys")) {
        if (part_system_exists(global.p_sys)) {
            part_type_destroy(global.p_trail);
            part_type_destroy(global.p_spark);
            part_type_destroy(global.p_slash);
            part_type_destroy(global.p_ring);
            part_type_destroy(global.p_shatter);
            if (variable_global_exists("p_string")) part_type_destroy(global.p_string);
            if (variable_global_exists("p_needle")) part_type_destroy(global.p_needle);
            part_system_destroy(global.p_sys);
        }
    }
}

// =====================================================================
// SPAWN API FUNCTIONS
// =====================================================================

/// @function particle_spawn_dash_trail(_x, _y)
function particle_spawn_dash_trail(_x, _y) {
    if (variable_global_exists("p_sys")) {
        part_particles_create(global.p_sys, _x, _y, global.p_trail, 2);
    }
}

/// @function particle_spawn_spark(_x, _y, _amount)
function particle_spawn_spark(_x, _y, _amount) {
    if (variable_global_exists("p_sys")) {
        part_particles_create(global.p_sys, _x, _y, global.p_spark, _amount);
    }
}

/// @function particle_spawn_slash(_x, _y, _dir, _amount)
function particle_spawn_slash(_x, _y, _dir, _amount = 10) {
    if (variable_global_exists("p_sys")) {
        part_type_direction(global.p_slash, _dir - 20, _dir + 20, 0, 0);
        part_particles_create(global.p_sys, _x, _y, global.p_slash, _amount);
    }
}

/// @function particle_spawn_ring_wave(_x, _y)
function particle_spawn_ring_wave(_x, _y) {
    if (variable_global_exists("p_sys")) {
        part_particles_create(global.p_sys, _x, _y, global.p_ring, 1);
    }
}

/// @function particle_spawn_shatter(_x, _y, _amount)
function particle_spawn_shatter(_x, _y, _amount = 12) {
    if (variable_global_exists("p_sys")) {
        part_particles_create(global.p_sys, _x, _y, global.p_shatter, _amount);
    }
}

/// @function particle_spawn_slime_trail(_x, _y)
function particle_spawn_slime_trail(_x, _y) {
    if (variable_global_exists("p_sys") && variable_global_exists("p_slime")) {
        part_particles_create(global.p_sys, _x, _y, global.p_slime, 1);
    }
}

/// @function particle_spawn_string_trail(_x, _y)
function particle_spawn_string_trail(_x, _y) {
    if (variable_global_exists("p_sys") && variable_global_exists("p_string")) {
        part_particles_create(global.p_sys, _x, _y, global.p_string, 2);
    }
}

/// @function particle_spawn_needle_burst(_x, _y, _dir, _amount)
function particle_spawn_needle_burst(_x, _y, _dir, _amount = 8) {
    if (variable_global_exists("p_sys") && variable_global_exists("p_needle")) {
        part_type_direction(global.p_needle, _dir - 15, _dir + 15, 0, 0);
        part_particles_create(global.p_sys, _x, _y, global.p_needle, _amount);
    }
}