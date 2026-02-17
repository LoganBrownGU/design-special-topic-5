$fn = 300;

lip_width = 1;
mirror_radius = 120;
translate([0, 0, 25])
	difference () {
		cylinder(5, mirror_radius, mirror_radius);
		cylinder(5, mirror_radius - lip_width, mirror_radius - lip_width);
	};

bezel_width = 20;
difference () {
	cylinder(30, mirror_radius + bezel_width, mirror_radius + bezel_width);
	cylinder(30, mirror_radius, mirror_radius);
};

focal_length = 900;
difference () {
	cylinder(20, mirror_radius, mirror_radius);
	translate([0, 0, 2 * focal_length + 10])
		sphere(2 * focal_length);
};

rotate([90, 0, 0]) translate([0, 15, 140])
	cylinder(150, 15, 15);

translate([-35, -290, 0])
	difference () {
		cube([70, 10, 30]);
		rotate([90, 0, ]) {
			translate([60, 15, -10]) cylinder(10, 5, 5);
			translate([10, 15, -10]) cylinder(10, 5, 5);
		}
	}
