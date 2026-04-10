include <config.scad>

module cutout(height) {
    linear_extrude(height) hull() {
        square([flue_lip_cutout_length - bolt_radius, bolt_radius * 2]);
        translate([flue_lip_cutout_length, bolt_radius]) circle(bolt_radius);
    }
}

module body() {
    hull() {
        linear_extrude(flue_slit_depth) square([flue_lip_length, flue_lip_breadth]);  
        translate([0, flue_lip_breadth, flue_lip_thickness]) rotate([180, 0, 0]) linear_extrude(INFTSML) square([flue_lip_length * 0.67, flue_lip_breadth]);  
    }
}

module lip() {
    difference() {
        body();
        translate([0, flue_lip_breadth / 2 - bolt_radius]) cutout(flue_lip_thickness);
    }
    
    step = 5;
    step_minor = 2.5;
    size = 4.5;
    for (i = [step_minor:step_minor:(flue_lip_length / 2)+step_minor]) {
        if (i % step != 0) {
            translate([i, 0,                flue_lip_thickness]) color("red") rotate([0, 0, 90]) linear_extrude(0.5) text(str("< ", i), size=size, valign="center");
           	translate([i, flue_lip_breadth, flue_lip_thickness]) color("red") rotate([0, 0, 90]) linear_extrude(0.5) text(str(i, " >"), size=size, valign="center", halign="right");
        } else {
            translate([i, 0,                flue_lip_thickness]) color("red") rotate([0, 0, 90]) linear_extrude(0.5) text("—", size=size, valign="center");
           	translate([i, flue_lip_breadth, flue_lip_thickness]) color("red") rotate([0, 0, 90]) linear_extrude(0.5) text("—", size=size, valign="center", halign="right");
        }
    }
}

lip();
