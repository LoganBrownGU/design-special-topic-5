include <config.scad>

use <blower-mount.scad>
use <lip.scad>
use <flue-lower.scad>
use <flue-middle.scad>
use <flue-upper.scad>

flue_lower_offset = blower_inset_depth + blower_middle_depth + blower_upper_depth + thread_pitch * 2.5;
flue_middle_offset = flue_lower_offset + flue_taper_into_slit;
flue_upper_offset = flue_middle_offset + flue_post_height + slide_rails_height / 2; 

module assembled() {
	color("red") blower_mount();
	translate([0, 0, flue_lower_offset]) color("purple") flue_lower();
	translate([0, 0, flue_middle_offset]) color("orange") flue_middle();
	translate([0, 0, flue_upper_offset]) color("blue") flue_upper();
	translate([flue_lip_breadth  / 2, flue_lip_y_offset, flue_upper_offset + 20]) rotate([-90, 90, 0]) color("yellow") lip();

}

projection(true) {
    rotate([90, 90, 180]) assembled();
}
projection(true) {
    translate([60, 0]) rotate([90, 0, 180]) assembled();
}
