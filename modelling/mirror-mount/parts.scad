$fn = $preview ? 32 : 256;
tap_fn = $preview ? 16 : 64;

use <threadlib/threadlib.scad>

include <config.scad>
include <housing.scad>
include <lip.scad>
include <base.scad>
include <stem-lower.scad>
include <stem-upper.scad>

translate([-100, 50, base_thickness]) rotate([-90, 0, 0])base();

translate([40, -40]) rotate([90, 0, 0]) stem_upper();

translate([100, -100]) stem_lower();

housing_offset =  -128 + (mirror_radius + housing_width + 0.5);
translate([housing_offset, housing_offset]) housing();
translate([-housing_offset, -housing_offset]) lip();

translate([-128, -128]) % square([256, 256]);
