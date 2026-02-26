$fn = $preview ? 32 : 256;
tap_fn = $preview ? 16 : 64;

use <threadlib/threadlib.scad>

include <config.scad>
include <housing.scad>
include <lip.scad>
include <base.scad>
include <stem.scad>

translate([-base_breadth / 2, -(mirror_radius + housing_width + stem_length), -base_length / 2 + stem_center]) base();

translate([0, 0, housing_height + 10]) lip();

if (!$preview) { translate([-stem_width / 2, -mirror_radius - housing_width - stem_length + stem_offset, stem_center]) rotate([-90, 0, 0]) stem(); }
else { translate([100, 0, 0]) stem(); }

housing();
