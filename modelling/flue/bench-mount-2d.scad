include <config.scad>
use <bench-mount-assembled.scad>

projection(true) {
    translate([blower_outer_radius,56.2,0]) rotate([90, 0]) body();
}
