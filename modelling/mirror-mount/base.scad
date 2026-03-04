
include <config.scad>

module slide_hole(radius, length, depth) { 
	translate([-radius, -length / 2 + radius, 0]) union () {
		cube([radius * 2, length - 2 * radius, depth]);
		translate([radius, 0, 0]) cylinder(depth, radius, radius);
		translate([radius, length - 2 * radius, 0]) cylinder(depth, radius, radius);
	}
}

module hole() {
	slide_hole(mount_hole_diameter / 2, 20, base_thickness);
	inset = mount_hole_diameter;
	translate([0, 0, base_thickness - base_thickness / 3]) slide_hole(mount_hole_diameter / 2  + inset, 20 + inset * 2, base_thickness / 3);
}

module base() { translate([-base_width / 2, 0]) {
	difference () {
		cube([base_width + 10, base_length, base_thickness]);
		translate([5, base_length - 30, base_thickness / 2]) 
			cube([base_width, frame_height, base_thickness / 2]);

		x_offset = pitch * 2; 
		y_offset = pitch * 2;
		translate([base_width / 2, base_length / 2 - 15]) {
	
			translate([-x_offset, -y_offset]) hole(); 
			translate([ x_offset, -y_offset]) hole(); 
			translate([-x_offset,  y_offset]) hole(); 
			translate([ x_offset,  y_offset]) hole(); 
		}
	}

	
}}

base();
