include <config.scad>
use <slide.scad>
use <flue-lower.scad>

INCLUDE_NOTCHES = true; 

module layer_1() {
    linear_extrude(clip_depth) difference() {
        square(slide_mount_width + slide_mount_wall_thickness, true);
        square(slide_mount_width, true);
    }
} 

module layer_2() { difference() {
    linear_extrude(slide_rails_depth) difference() {
        square(slide_mount_width + slide_mount_wall_thickness, true);
        scale([+1, 1]) translate(slide_rails_offset) square([slide_rails_width, slide_rails_length], true);
        scale([-1, 1]) translate(slide_rails_offset) square([slide_rails_width, slide_rails_length], true);
        slit(INCLUDE_NOTCHES);
    }
     
    if (INCLUDE_NOTCHES) translate([0, slide_mount_width / 3, slide_rails_depth / 2]) linear_extrude(slide_rails_depth) rotate([0, 0, 180]) text(str("n=", NOTCH_COUNT), font="courier new", size=slide_mount_width / 5, halign="center");
    else                 translate([0, slide_mount_width / 3, slide_rails_depth / 2]) linear_extrude(slide_rails_depth) rotate([0, 0, 180]) text("n=0",                  font="courier new", size=slide_mount_width / 5, halign="center");
}}

back_wall_thickness = abs(-(slide_mount_width / 2 + slide_mount_wall_thickness / 2) - (slide_rails_offset.y - slide_rails_length / 2));
back_wall_offset = [0, slide_rails_offset.y - slide_rails_length / 2 - back_wall_thickness / 2];
module layer_3() {
    linear_extrude(flue_post_height - flue_middle_to_upper_inset_depth) 
        translate(back_wall_offset) square([slide_mount_width, back_wall_thickness], true);
}

module layer_4() {
    linear_extrude(flue_middle_to_upper_inset_depth) difference() {
        translate(back_wall_offset)                  square([slide_mount_width, back_wall_thickness], true);  
        translate(flue_middle_to_upper_inset_offset) square([flue_middle_to_upper_inset_width, flue_middle_to_upper_inset_thickness], true);
    }
}

module flue_middle() {
    translate([0, 0, -clip_depth]) layer_1();
    translate([0, 0, 0]) layer_2();
    translate([0, 0, slide_rails_depth]) layer_3();
    translate([0, 0, slide_rails_depth + flue_post_height - flue_middle_to_upper_inset_depth]) layer_4();
}

flue_middle();

// translate([50, 50]) slit(true);
