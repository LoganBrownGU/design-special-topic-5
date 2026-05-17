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
}

module slit(include_notches) {
    translate([-flue_slit_length / 2, -(-slide_mount_width / 2 + flue_slit_offset) - flue_slit_depth]) {
	    square([flue_slit_length, flue_slit_depth]);
		if (include_notches) {
	    	offset_x = flue_slit_length / (NOTCH_COUNT+1);
	    	for (i = [1:NOTCH_COUNT]) {
	     		translate([i * offset_x, -0.5*NOTCH_DEPTH]) square([NOTCH_WIDTH, NOTCH_DEPTH], true);
		    }
	    }
    } 

    
}

module flue_taper() {
    difference() {
        flue_taper_ext();
        hull () {
            linear_extrude(10) circle(blower_inset_radius);
            translate([0, 0, flue_taper_into_slit]) linear_extrude(INFTSML) slit(false);
        }
        translate([0, 0, flue_taper_into_slit]) linear_extrude(flue_floor_thickness) slit(false);
    }

}

module flue_lower() {
    rotate([180, 0, 0]) translate([0, 0, 2.2]) slide_mount_thread();
    
    intersection() {
        flue_taper(); 
        hull() {
            translate([0, 0, flue_taper_into_slit + flue_floor_thickness]) linear_extrude(-INFTSML) square([slide_mount_width, slide_mount_width], true);
            translate([0, 0, flue_taper_into_slit]) linear_extrude(INFTSML) square([slide_mount_width, slide_mount_width], true);
            linear_extrude(INFTSML) circle(blower_inner_radius);
        }
    }
    
}

flue_lower();
