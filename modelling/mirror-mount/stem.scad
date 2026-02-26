module stem_outer() {
	difference() {
		cube([stem_width + stem_outer_thickness, stem_width + stem_outer_thickness, stem_length / 2]);

		x_offset = (stem_width + stem_outer_thickness) / 2;
		translate([x_offset, 0, stem_length / 2 - x_offset]) rotate([-90, 0, 0]) 
			tap("M5", turns=stem_tap_turns, fn=tap_fn);
	}
}

// stem
module stem() {
	//cylinder(stem_length + stem_offset, stem_radius, stem_radius);
	translate([0, 0, stem_length / 2]) cube([stem_width, stem_width, stem_length / 2 + stem_overlap]);
	
	difference() {
		translate([-stem_outer_thickness / 2, -stem_outer_thickness  / 2, 0])
			stem_outer();
			
		translate([-stem_tolerance / 2, -stem_tolerance / 2, 0]) 
			cube([stem_width + stem_tolerance, stem_width + stem_tolerance, stem_length / 2]);
	}
};


