
use <threadlib/threadlib.scad> 
use <clip.scad>
include <config.scad>



translate([ 10, 0, 0]) { translate([0, 0, 2]) clip_outer(0.4, 10, 10); linear_extrude(2) difference() { square([15, 15], true); square([10 - 1.6, 10 - 1.6], true); } }
translate([-10, 0, 0]) { translate([0, 0, 2]) clip_inner(0.4, 10, 10); linear_extrude(2) square([15, 15], true); }
