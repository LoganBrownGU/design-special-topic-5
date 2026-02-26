module stem_outer() {
	difference() {
		cube([stem_width + stem_outer_thickness, stem_width + stem_outer_thickness, stem_length / 2]);

		x_offset = (stem_width + stem_outer_thickness) / 2;
		translate([x_offset, 0, stem_length / 2 - x_offset]) rotate([-90, 0, 0]) 
			tap("M5", turns=stem_tap_turns, fn=tap_fn);
	}
}

// stem
module stem_lower() {
	difference() {
		stem_outer();
		
		xy_offset = (stem_outer_thickness - stem_tolerance) / 2;
		translate([xy_offset, xy_offset, 0])
			cube([stem_width + stem_tolerance, stem_width + stem_tolerance, stem_length / 2]);
	}
};


