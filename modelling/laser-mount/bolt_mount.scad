include <config.scad>

use <laser_mount.scad>

module hexagon(width) {
	diagonal = width * tan(30) + (width / 2) / cos(30);
	polygon(points = [
		[0, diagonal / 2],
		[width / 2,  width * tan(30) / 2],
		[width / 2, -width * tan(30) / 2],
		[0, -diagonal / 2],
		[-width / 2, -width * tan(30) / 2],
		[-width / 2,  width * tan(30) / 2],
	]);
}

module bolt_mount() {
	difference() {
		linear_extrude(bolt_hex_length + bolt_cap + laser_inset) hexagon(bolt_mount_width);	
		linear_extrude(bolt_hex_length)            hexagon(bolt_hex_width);
		translate([0, laser_length_2, bolt_hex_length + bolt_cap + laser_sleeve_radius - laser_inset]) rotate([90, 0, 0])
			laser_mount();
	}
}

bolt_mount();
