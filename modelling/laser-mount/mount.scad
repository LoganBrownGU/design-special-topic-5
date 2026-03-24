include <config.scad>

use <bolt_mount.scad>
use <laser_mount.scad>

module mount() {
	union() {
		translate([0, laser_length_2, bolt_hex_length + bolt_cap + laser_sleeve_radius - laser_inset]) rotate([90, 0, 0])
			laser_mount();
		bolt_mount();
	}
}

mount();
