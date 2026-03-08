include <config.scad>

module frame() { 
	translate([frame_width / 2 - 2.5, frame_height]) difference() {
		 cube([5, 5, 5]);
		 translate([2.5, 1, 2.5]) rotate([-90, 0, 0]) 
			cylinder(4, bolt_hole_radius, bolt_hole_radius);
	}

	difference() {
		linear_extrude(frame_depth) difference() {
			square([frame_width, frame_height]);
			translate([frame_thickness, frame_thickness]) square([switch_width, switch_height]);
		}

		translate([frame_width - frame_thickness / 2, frame_height / 2, 0])
			cylinder(frame_depth - 1, (frame_thickness - 1) / 2, (frame_thickness - 1) / 2);
		translate([frame_thickness / 2, frame_height / 2, 0])
			cylinder(frame_depth - 1, (frame_thickness - 1) / 2, (frame_thickness - 1) / 2);

	}
}

module clip() {
	linear_extrude(2) square([frame_width, frame_thickness - 1]);
	translate([frame_width - frame_thickness / 2, (frame_thickness - 1) / 2, 0])
		cylinder(frame_depth - 1 + 4, (frame_thickness - 1) / 2, (frame_thickness - 1) / 2);
	translate([frame_thickness / 2, (frame_thickness - 1) / 2, 0])
		cylinder(frame_depth - 1 + 4, (frame_thickness - 1) / 2, (frame_thickness - 1) / 2);

}

translate([0, 20]) frame();
clip();
