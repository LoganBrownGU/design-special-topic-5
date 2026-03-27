include <config.scad>

use <threadlib/threadlib.scad> 

module slide_mount_bolt() {
    bolt(thread_size, turns=thread_turns, fn=thread_fn);
}

module slide_mount_thread() {
    difference() {
        slide_mount_bolt();
        translate([0, 0, -thread_pitch]) cylinder(thread_pitch * (thread_turns + 2), blower_inset_radius, blower_inset_radius); 
    }
} 

module flue_taper_ext() {
    translate([0, 0, (flue_taper_into_slit + flue_floor_thickness) / 2]) 
        cube([slide_mount_width, slide_mount_width, flue_taper_into_slit + flue_floor_thickness], true);
        
    width = slide_mount_width - 2 * clip_depth - 2 * slide_mount_wall_thickness;
    translate([0, 0, flue_taper_into_slit + flue_floor_thickness + clip_depth / 2])
        cube([width, width, clip_depth], true);
    translate([0, 0, flue_taper_into_slit + flue_floor_thickness + clip_depth * 1.5])
        cube([width + 2 * clip_depth, width + 2 * clip_depth, clip_depth], true);
}

module flue_taper() {
    difference() {
        flue_taper_ext();
        hull () {
            translate([0, 0, -0.5]) linear_extrude(1) circle(blower_inset_radius);
            translate([-flue_slit_length / 2, -slide_mount_width / 2 + flue_slit_offset, flue_taper_into_slit])
                linear_extrude(flue_floor_thickness + clip_depth * 2)  square([flue_slit_length, flue_slit_depth]);
        }
    }
}

module flue_lower() {
    rotate([180, 0, 0]) translate([0, 0, 2.2]) slide_mount_thread();
    flue_taper(); 
}

flue_lower();
