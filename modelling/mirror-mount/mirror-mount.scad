$fn = $preview ? 32 : 128;
tap_fn = $preview ? 16 : 64;

use <threadlib/threadlib.scad>

module slide_hole(radius, length, depth) {
	translate([-radius, -length / 2 + radius, 0]) union () {
		cube([radius * 2, length - 2 * radius, depth]);
		translate([radius, 0, 0]) cylinder(depth, radius, radius);
		translate([radius, length - 2 * radius, 0]) cylinder(depth, radius, radius);
	}
}

mirror_radius = 114 / 2;
mirror_thickness = 14;
focal_length = 900;

lip_width = 1;
lip_height = 2;
housing_width = 10;
housing_height = mirror_thickness * 2;

tapped_hole_offset = mirror_radius + housing_width / 2;
tap_depth = 10;
tap_turns = 10 / 0.8;

stem_length = 150;
stem_radius = (housing_height + lip_height) / 4;
stem_center = (housing_height + lip_height) / 2;

pitch = 25;
mounting_hole_radius = 5 / 2;
mounting_hole_length = 15;
base_length = pitch + 2 * mounting_hole_length;
base_breadth = pitch + 4 * mounting_hole_radius;
base_thickness = 10;

// curved back
difference () {
	sphere_radius = 2 * focal_length;
	sphere_offset = sphere_radius - sqrt(sphere_radius^2 - (mirror_radius)^2);
	cylinder(sphere_offset, mirror_radius, mirror_radius);
	translate([0, 0, sphere_radius + mirror_thickness - sphere_offset])
		sphere(sphere_radius);
};

// housing
difference () {
	cylinder(housing_height, mirror_radius + housing_width, mirror_radius + housing_width);

	// central hole
	cylinder(housing_height, mirror_radius, mirror_radius);

	// tap holes
	rotate([180, 0, 0]) {
		translate([ tapped_hole_offset, 0, -housing_height]) tap("M5", turns=tap_turns, fn=tap_fn);
		translate([-tapped_hole_offset, 0, -housing_height]) tap("M5", turns=tap_turns, fn=tap_fn);
	}
};

// lip
translate([0, 0, housing_height + 10]) {
	difference () {
		cylinder(lip_height, mirror_radius + housing_width, mirror_radius + housing_width);
	
	// central hole
		cylinder(lip_height, mirror_radius - lip_width, mirror_radius - lip_width);
		// bolt holes
		translate([tapped_hole_offset, 0, 0]) cylinder(lip_height, mounting_hole_radius, mounting_hole_radius);
		translate([-tapped_hole_offset, 0, 0]) cylinder(lip_height, mounting_hole_radius, mounting_hole_radius);

	};
};


// stem
stem_offset = housing_width / 2;
rotate([90, 0, 0]) translate([0, stem_center, mirror_radius + housing_width - stem_offset]) {
	cylinder(stem_length + stem_offset, stem_radius, stem_radius);
};


module hole() { slide_hole(mounting_hole_radius, mounting_hole_length, base_thickness); }
translate([-base_breadth / 2, -(mirror_radius + housing_width + stem_length), -base_length / 2 + stem_center]) {
	difference () {
		cube([base_breadth, base_thickness, base_length]);
		rotate([90, 0, 0]) {
			edge_offset_x = base_length / 2 - pitch / 2;
			edge_offset_y = base_breadth / 2 - pitch / 2;
			// bottom right
			translate([base_breadth - edge_offset_y, edge_offset_x, -base_thickness]) hole();
			// bottom left
			translate([edge_offset_y, edge_offset_x, -base_thickness]) hole();
			// top right
			translate([base_breadth - edge_offset_y, base_length - edge_offset_x, -base_thickness]) hole();
			// top left
			translate([edge_offset_y, base_length - edge_offset_x, -base_thickness]) hole();
		}
	}
}

