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

module flue_taper() {

    difference() {
        translate([-slide_mount_width / 2, -slide_mount_width / 2]) cube([slide_mount_width, slide_mount_width, flue_taper_into_slit]);
        hull () {
            translate([0, 0, -0.5]) linear_extrude(1) circle(blower_inset_radius);
            translate([-flue_slit_length / 2, -slide_mount_width / 2 + flue_slit_offset, flue_taper_into_slit])
                linear_extrude(flue_floor_thickness)  square([flue_slit_length, flue_slit_depth]);
        }
    }
}

module slide_mount_lower() {
    rotate([180, 0, 0]) slide_mount_thread();
    flue_taper(); 
}

slide_mount_lower();
