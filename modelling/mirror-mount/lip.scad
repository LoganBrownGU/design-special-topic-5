include <config.scad>

// lip
module lip() {
	difference () {
		cylinder(lip_height, mirror_radius + housing_width, mirror_radius + housing_width);
	
		// central hole
		cylinder(lip_height, mirror_radius - lip_width, mirror_radius - lip_width);
		// bolt holes
		translate([tapped_hole_offset, 0, 0]) cylinder(lip_height, mounting_hole_radius, mounting_hole_radius);
		translate([-tapped_hole_offset, 0, 0]) cylinder(lip_height, mounting_hole_radius, mounting_hole_radius);

	};
};


lip();

