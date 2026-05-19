include <config.scad>
use <beam-splitter-mount.scad>
use <stem.scad>

projection(true) rotate([90, 0]) stem();
projection() translate([0, -BOLT_HEX_LENGTH - BEAM_SPLITTER_WIDTH / 2 - HOLDER_THICKNESS]) rotate([90, 0])  holder();
