
module housing() {
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

}
