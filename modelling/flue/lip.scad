include <config.scad>

module cutout() {
    linear_extrude(flue_lip_thickness) hull() {
        square([flue_lip_length / 2 - bolt_radius, bolt_radius * 2]);
        translate([flue_lip_length / 2, bolt_radius]) circle(bolt_radius);
    }
}

module body() {
    hull() {
        linear_extrude(INFTSML) square([flue_lip_length, flue_lip_breadth]);  
        translate([0, flue_lip_breadth, flue_lip_thickness]) rotate([180, 0, 0]) linear_extrude(INFTSML) square([flue_lip_length * 0.67, flue_lip_breadth]);  
    }
}

module lip() {
    difference() {
        body();
        translate([0, flue_lip_breadth / 2 - bolt_radius]) cutout();
    }
}

lip();
