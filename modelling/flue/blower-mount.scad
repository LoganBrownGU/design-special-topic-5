include <config.scad>

use <threadlib/threadlib.scad> 

module blower_lip() {
    translate([-blower_lip_width / 2, -blower_lip_depth]) square([blower_lip_width, blower_lip_depth]);
}

module blower_lower() {
    linear_extrude(blower_inset_depth) difference() {
        circle(blower_inner_radius);
        circle(blower_inset_radius);
        translate([0, blower_inner_radius])  rotate([0, 0, 0]) blower_lip();
        translate([blower_inner_radius, 0])  rotate([0, 0, 270]) blower_lip();
        translate([-blower_inner_radius, 0]) rotate([0, 0, 90]) blower_lip();
        translate([0, -blower_inner_radius]) rotate([0, 0, 180]) blower_lip();
    }
}

module blower_middle() {
    linear_extrude(blower_middle_depth) difference() {
        circle(blower_inner_radius - blower_lip_depth);
        circle(blower_inset_radius);
    }
}

module blower_upper() {
    linear_extrude(blower_upper_depth) difference() {
        circle(blower_outer_radius);
        circle(blower_inset_radius);
    }
    translate([0, 0, blower_upper_depth]) nut("M42", turns=2, Douter=blower_outer_radius * 2, fn=thread_fn);
}

module blower_mount() {
    blower_lower();
    translate([0, 0, blower_inset_depth]) blower_middle();
    translate([0, 0, blower_inset_depth + blower_middle_depth]) blower_upper();
}

blower_mount();
