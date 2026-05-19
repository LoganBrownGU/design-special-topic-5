

include <config.scad>
use <slide.scad>
use <flue-lower.scad>
use <flue-middle.scad>

// flue_middle();
projection(true) {
    translate([0, (slide_mount_width+slide_mount_wall_thickness)/2]) flue_middle();     
    translate([0, 60]) rotate([0, -90, -90]) flue_middle();
}
