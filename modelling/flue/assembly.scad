include <config.scad>

use <blower-mount.scad>
use <lip.scad>
use <flue-lower.scad>
use <upper.scad>

translate([0, 0, -50]) blower_mount();
flue_lower();
