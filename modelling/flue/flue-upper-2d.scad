include <config.scad>
use <flue-upper.scad>


projection(true) {
    translate([slide_mount_width * 0.5, 0]) rotate([-90,0]) flue_upper();
    translate([60 + slide_mount_width/2, 0, -slide_mount_width/2.1]) rotate([-90,0]) flue_upper();
    translate([120 + slide_mount_width/2, 0, slide_mount_width/2 - flue_lip_thickness * 1.5 ]) rotate([-90,0]) flue_upper();
}
