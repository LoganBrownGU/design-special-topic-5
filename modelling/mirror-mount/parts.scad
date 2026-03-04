
include <config.scad>
use <frame.scad>
use <base.scad>

module parts() {

	translate([100, 0]) frame();
	translate([-100, 0]) base();

}

parts();
