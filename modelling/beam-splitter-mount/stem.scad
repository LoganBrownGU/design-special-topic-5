include <config.scad>



module stem() {
	linear_extrude(BOLT_HEX_LENGTH) difference() {
		hexagon(BOLT_HEX_WIDTH + BOLT_MOUNT_THICKNESS);
		hexagon(BOLT_HEX_WIDTH);
	}
	translate([0, 0, BOLT_HEX_LENGTH]) linear_extrude(BOLT_MOUNT_CAP) hexagon(BOLT_HEX_WIDTH + BOLT_MOUNT_THICKNESS);
}

stem();
