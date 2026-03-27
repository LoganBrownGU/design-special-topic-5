include <config.scad>

use <blower-mount.scad>
use <lip.scad>
use <flue-lower.scad>
use <flue-middle.scad>
use <upper.scad>
use <flue-upper.scad>

flue_lower_offset = blower_inset_depth + blower_middle_depth + blower_upper_depth + thread_pitch * 2.5;
flue_middle_offset = flue_lower_offset + flue_taper_into_slit + flue_floor_thickness;
flue_upper_offset = flue_middle_offset + flue_post_height + slide_rails_height; 

color("red") blower_mount();
translate([0, 0, flue_lower_offset]) rotate([0, 0, 180]) color("purple") flue_lower();
translate([0, 0, flue_middle_offset]) color("orange") flue_middle();
translate([0, 0, flue_upper_offset]) color("blue") flue_upper();
translate([flue_lip_breadth  / 2, slide_mount_width / 2, flue_upper_offset + 11.5]) rotate([-90, 90, 0]) color("yellow") lip();
