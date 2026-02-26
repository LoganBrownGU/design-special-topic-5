$fn = $preview ? 32 : 256;
tap_fn = $preview ? 16 : 64;

use <threadlib/threadlib.scad>

include <config.scad>
include <housing.scad>
include <lip.scad>
include <base.scad>
include <stem-lower.scad>
include <stem-upper.scad>

translate([-200, 0, 0]) rotate([-90, 0, 0]) base();
translate([300, 0, 0]) lip();
translate([100, 0, 0]) rotate([90, 0, 0]) stem_upper();
translate([200, 0, 0]) rotate([90, 0, 0]) stem_lower();
housing();

