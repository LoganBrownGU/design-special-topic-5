include <config.scad>

use <bolt_mount.scad>
use <led_mount.scad>
use <pinhole_insert.scad>

led_mount();
translate([100, 0]) pinhole_insert();
translate([0, 100]) bolt_mount();
