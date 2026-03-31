include <config.scad>

use <threadlib/threadlib.scad> 
use <clip.scad>

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
        
    // translate([0, 0, flue_taper_into_slit + flue_floor_thickness]) difference() {
        // translate([0, -slide_mount_width / 2 + flue_slit_offset]) linear_extrude(clip_depth * 3) square([flue_slit_length, flue_slit_depth], true);
    // }
}

module flue_taper() {
    difference() {
        flue_taper_ext();
        hull () {
            linear_extrude(1) circle(blower_inset_radius);
            translate([0, -slide_mount_width / 2 + flue_slit_offset, flue_taper_into_slit])
                linear_extrude(INFTSML) square([flue_slit_length, flue_slit_depth], true);
        }
        
        translate([0, -slide_mount_width / 2 + flue_slit_offset, flue_taper_into_slit]) linear_extrude(flue_floor_thickness) square([flue_slit_length, flue_slit_depth], true);
    }
}

module flue_lower() {
    rotate([180, 0, 0]) translate([0, 0, 2.2]) slide_mount_thread();
    
    intersection() {
        flue_taper(); 
        hull() {
            translate([0, 0, flue_taper_into_slit + flue_floor_thickness + clip_depth * 2]) linear_extrude(INFTSML) square([slide_mount_width, slide_mount_width], true);
            translate([0, 0, flue_taper_into_slit]) linear_extrude(INFTSML) square([slide_mount_width, slide_mount_width], true);
            linear_extrude(INFTSML) circle(blower_inner_radius);
        }
    }
    
}

flue_lower();
