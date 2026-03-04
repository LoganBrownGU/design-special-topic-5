
include <config.scad>
use <frame.scad>

module parts() {

    frame();

	translate([-128, -128]) % square([256, 256]);
}

parts();
