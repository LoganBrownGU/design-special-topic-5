include <config.scad>

use <blower-mount.scad>
use <lip.scad>
use <flue-lower.scad>
use <flue-middle.scad>
use <upper.scad>

// translate([0, 0, -150]) blower_mount();
translate([0, 0, -30]) flue_lower();
flue_middle();
