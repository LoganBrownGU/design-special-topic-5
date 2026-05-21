include <config.scad>
use <flue-lower.scad>

projection(true) {
    translate([0, 0]) rotate([-90, 90]) flue_lower();
    translate([30 + slide_mount_width/2,  0, -flue_taper_into_slit+0.01]) flue_lower();
    // translate([0, 100 + blower_inset_radius]) flue_lower();
}
