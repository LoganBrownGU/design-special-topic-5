include <config.scad>

use <blower-mount.scad>
use <lip.scad>
use <flue-lower.scad>
use <flue-middle.scad>
use <upper.scad>
use <flue-upper.scad>

translate([0, 0, -110]) color("red") blower_mount();
translate([0, 0, -65]) rotate([0, 0, 180]) color("purple") flue_lower();
translate([0, 0, -35]) color("orange") flue_middle();
color("blue") flue_upper();
translate([flue_lip_breadth  / 2, 50, 15]) rotate([-90, 90, 0]) color("yellow") lip();
