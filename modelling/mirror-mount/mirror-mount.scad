$fn = 300;

module slide_hole(radius, length, depth) {
	translate([-radius, -length / 2 + radius, 0]) union () {
		cube([radius * 2, length - 2 * radius, depth]);
		translate([radius, 0, 0]) cylinder(depth, radius, radius);
		translate([radius, length - 2 * radius, 0]) cylinder(depth, radius, radius);
	}
}

// lip
lip_width = 1;
mirror_radius = 120;
translate([0, 0, 25]) {
	difference () {
		cylinder(5, mirror_radius, mirror_radius);
		cylinder(5, mirror_radius - lip_width, mirror_radius - lip_width);
	};
};

// housing
bezel_width = 20;
housing_height = 30;
difference () {
	cylinder(housing_height, mirror_radius + bezel_width, mirror_radius + bezel_width);
	cylinder(housing_height, mirror_radius, mirror_radius);
};

// curved back
focal_length = 900;
difference () {
	cylinder(20, mirror_radius, mirror_radius);
	translate([0, 0, 2 * focal_length + 10])
		sphere(2 * focal_length);
};

// stem
stem_length = 150;
stem_radius = 15;
rotate([90, 0, 0]) translate([0, stem_radius, mirror_radius + bezel_width]) {
	cylinder(stem_length, stem_radius, stem_radius);
};

pitch = 50;
hole_width = 5;
base_length = pitch * 2 + hole_width * 4;
base_breadth = pitch + hole_width * 4;
base_thickness = 10;
module hole() { slide_hole(hole_width, 25, base_thickness); }
translate([-base_length / 2, -(mirror_radius + bezel_width + stem_length), -base_length / 2 + stem_radius]) {
	difference () {
		cube([base_breadth, base_thickness, base_length]);
		rotate([90, 0, 0]) {
			edge_offset_x = base_length / 2 - pitch / 2;
			edge_offset_y = base_breadth / 2 - pitch / 2;
			translate([base_length - edge_offset_y, stem_radius, -base_thickness]) hole();
			translate([edge_offset_y,               stem_radius, -base_thickness]) hole();
			translate([base_breadth - edge_offset_x, base_length - stem_radius, -base_thickness]) hole();
			translate([edge_offset_x,               base_length - stem_radius, -base_thickness]) hole();
		}
	}
}

