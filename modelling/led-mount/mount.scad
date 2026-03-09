include <config.scad>

module frame() { 
	translate([frame_width / 2 - bolt_hole_radius * 1.5, frame_height]) difference() {
		 cube([bolt_hole_radius * 3, 5, frame_depth]);
		 translate([bolt_hole_radius * 1.5, 1, frame_depth / 2]) rotate([-90, 0, 0]) 
			cylinder(4, bolt_hole_radius, bolt_hole_radius);
	}

	difference() {
		linear_extrude(frame_depth) difference() {
			square([frame_width, frame_height]);
			translate([frame_thickness, frame_thickness]) square([switch_width, switch_height]);
		}

		translate([frame_width - frame_thickness / 2, frame_height / 2, 0])
			cylinder(frame_depth - 1, clip_hole_radius, clip_hole_radius);
		translate([frame_thickness / 2, frame_height / 2, 0])
			cylinder(frame_depth - 1, clip_hole_radius, clip_hole_radius);

	}
}

module clip() {
	linear_extrude(2) square([frame_width, frame_thickness]);
	translate([frame_width - frame_thickness / 2, frame_thickness / 2, 0])
		cylinder(frame_depth - 1 + 4, clip_rod_radius, clip_rod_radius);
	translate([frame_thickness / 2, clip_hole_radius, 0])
		cylinder(frame_depth - 1 + 4, clip_rod_radius, clip_rod_radius);

}

translate([0, 20]) frame();
clip();
