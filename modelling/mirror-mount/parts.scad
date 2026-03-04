
include <config.scad>
use <frame.scad>
use <base.scad>
use <spring-fitting.scad>

module parts() {

	translate([100, 0]) frame();
	translate([-100, 0]) base();
	translate([-100, -100]) spring_fitting_inset();


}

parts();
