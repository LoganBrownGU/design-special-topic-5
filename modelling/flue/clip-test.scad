
use <threadlib/threadlib.scad> 
use <clip.scad>
include <config.scad>


depth = 1;
height = 1;

translate([ 10, 0, 0]) { translate([0, 0, 2]) clip_outer(depth, 10, 10); linear_extrude(2) difference() { square([15, 15], true); square([10 - 4 * depth, 10 - 4 * depth], true); } }
translate([-10, 0, 0]) { translate([0, 0, 2]) clip_inner(depth, 10, 10); linear_extrude(2) square([15, 15], true); }
