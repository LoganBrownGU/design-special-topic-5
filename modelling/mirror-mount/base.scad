module slide_hole(radius, length, depth) {
	translate([-radius, -length / 2 + radius, 0]) union () {
		cube([radius * 2, length - 2 * radius, depth]);
		translate([radius, 0, 0]) cylinder(depth, radius, radius);
		translate([radius, length - 2 * radius, 0]) cylinder(depth, radius, radius);
	}
}

module hole() { slide_hole(mounting_hole_radius, mounting_hole_length, base_thickness); }


module base() {
	difference () {
		cube([base_breadth, base_thickness, base_length]);

		// mounting holes
		rotate([90, 0, 0]) {
			edge_offset_x = base_length / 2 - pitch / 2;
			edge_offset_y = base_breadth / 2 - pitch;
			// bottom right
			translate([base_breadth - edge_offset_y, edge_offset_x, -base_thickness]) hole();
			// bottom left
			translate([edge_offset_y, edge_offset_x, -base_thickness]) hole();
			// top right
			translate([base_breadth - edge_offset_y, base_length - edge_offset_x, -base_thickness]) hole();
			// top left
			translate([edge_offset_y, base_length - edge_offset_x, -base_thickness]) hole();
		}

		// stem inset
		stem_total = stem_width + stem_outer_thickness;
		translate([(base_breadth - stem_total) / 2, 0, (base_length - stem_total) / 2]) cube([stem_total, base_thickness / 2, stem_total]);
	}
}

