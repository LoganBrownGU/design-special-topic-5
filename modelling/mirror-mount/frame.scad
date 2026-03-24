include <config.scad>
use <spring-fitting.scad>

module frame_triangle_inner() {
	side_length = mount_point_distance - frame_side_length_diff;
	polygon(points = triangle_points(side_length));
}

module frame_triangle_outer() {
	side_length = mount_point_distance + frame_side_length_diff;
	polygon(points = triangle_points(side_length));
}



module base_frame() {
	linear_extrude(frame_height) difference () {
		frame_triangle_outer();
		frame_triangle_inner();	

		// mounting holes
		mounting_points = triangle_points(mount_point_distance);
		echo(abs(mounting_points[0][1] - mounting_points[2][1]) / 2 + stand_height + base_thickness / 2);
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
			translate(point) cylinder(frame_height / 3, 4.25, 4.25);
		}
	}

	for (point = mounting_points) {
		translate(point) translate([0, 0, frame_height]) difference() {
			spring_fitting();
			cylinder(1.3 + 2.6, mount_hole_diameter / 2, mount_hole_diameter / 2); 
		}
	}
	
	translate([-stand_width / 2, mounting_points[1][1] - stand_height - frame_width / 2 - sleeve_height]) { 
		linear_extrude(frame_height) { difference () {
			square([stand_width, stand_height + sleeve_height]); 
			translate([stand_width / 2 - cutout_width / 2, 0]) square([cutout_width, cutout_height]);
		}}
	}


	translate([-40, -50, frame_height]) scale(0.8) 
		linear_extrude(1) text("this side forward");

}}

frame();
