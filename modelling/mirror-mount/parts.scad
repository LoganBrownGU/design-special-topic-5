

use <threadlib/threadlib.scad>

include <config.scad>
use <housing.scad>
use <lip.scad>
use <base.scad>
use <stem-lower.scad>
use <stem-upper.scad>

module parts() { 
	translate([-100, 50, base_thickness]) rotate([-90, 0, 0])base();

	translate([40, -40]) rotate([90, 0, 0]) stem_upper();

	translate([100, -100]) stem_lower();

	housing_offset =  -128 + (mirror_radius + housing_width + 0.5);
	translate([housing_offset, housing_offset]) housing();
	translate([-housing_offset, -housing_offset]) lip();

	translate([-128, -128]) % square([256, 256]);
}

parts();
