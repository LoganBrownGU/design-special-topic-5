include <config.scad>

module beam_splitter() {
	color("red") cube(BEAM_SPLITTER_WIDTH, true);
}

module holder() {
	holder_width = BEAM_SPLITTER_WIDTH + HOLDER_THICKNESS / 2;
	
	difference() {
		translate([0, 0, -HOLDER_THICKNESS / 2]) cube(holder_width, true);

		beam_splitter();
		
		cube([BEAM_SPLITTER_WIDTH - HOLDER_THICKNESS / 2, holder_width, BEAM_SPLITTER_WIDTH], true);
		cube([holder_width, BEAM_SPLITTER_WIDTH - HOLDER_THICKNESS / 2, BEAM_SPLITTER_WIDTH], true);

		translate([0, 0, -(holder_width + HOLDER_THICKNESS) / 2]) linear_extrude(BOLT_MOUNT_CAP) hexagon(BOLT_HEX_WIDTH + BOLT_MOUNT_THICKNESS);
	}
}


// beam_splitter();
holder();
