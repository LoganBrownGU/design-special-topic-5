

include <config.scad>
use <slide.scad>
use <flue-lower.scad>
use <flue-middle.scad>

// flue_middle();
projection(true) {
    translate([0, 0]) flue_middle();     
    translate([slide_mount_width, 0]) rotate([0, 90]) flue_middle();
}
