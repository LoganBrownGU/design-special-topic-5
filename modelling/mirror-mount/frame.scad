include <config.scad>

module frame_triangle_inner() {
	side_length = mount_point_distance - frame_side_length_diff;
	polygon(points = triangle_points(side_length));
}

module frame_triangle_outer() {
	side_length = mount_point_distance + frame_side_length_diff;
	polygon(points = triangle_points(side_length));
}

module spring_fitting() {
	union () {
		cylinder(1.3, 6.5, 6.5);
		cylinder(1.3 + 2.6, 4.5, 4.5);
	}
}

module base_frame() {
	linear_extrude(frame_height) difference () {
		frame_triangle_outer();
		frame_triangle_inner();	

		// mounting holes
		mounting_points = triangle_points(mount_point_distance);
		for (point = mounting_points) {
			translate(point) circle(d = mount_hole_diameter);
		}
	}

}

module frame() { union () {

	mounting_points = triangle_points(mount_point_distance);
	difference() {
		base_frame();
		for (point = mounting_points) {
			translate(point) spring_fitting(); 
		}
	}

	for (point = mounting_points) {
		translate(point) translate([0, 0, frame_height]) {
			difference() {
				spring_fitting(); 
				cylinder(1.3 + 2.6, mount_hole_diameter / 2, mount_hole_diameter / 2);
			}
		}
	}

	
	stand_width = mount_point_distance + (frame_width * cos(30) / cos(60));
	cutout_width = stand_width / 2;
	cutout_height = stand_height / 2;
	translate([-stand_width / 2, mounting_points[1][1] - stand_height - frame_width / 2]) { 
		linear_extrude(frame_height) { difference () {
			square([stand_width, stand_height]); 
			translate([stand_width / 2 - cutout_width / 2, 0]) square([cutout_width, cutout_height]);
		}}
	}


}}

frame();
