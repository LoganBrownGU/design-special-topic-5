include <config.scad>

use <spring-fitting.scad>
use <frame.scad>
use <base.scad>

projection(true) {
    translate([0, 116]) frame();

    translate([0, 370]) rotate([0, 0, 180]) base();
}
