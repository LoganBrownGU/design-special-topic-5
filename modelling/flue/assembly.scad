include <config.scad>

use <blower-mount.scad>
use <lip.scad>
use <flue-lower.scad>
use <flue-middle.scad>
use <upper.scad>
use <flue-upper.scad>

// translate([0, 0, -150]) blower_mount();
translate([0, 0, -65]) flue_lower();
translate([0, 0, -35]) flue_middle();
flue_upper();
