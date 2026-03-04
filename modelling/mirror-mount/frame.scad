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
			translate(point) {
				spring_fitting(); 
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
