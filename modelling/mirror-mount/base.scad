
include <prism-chamfer/prism-chamfer.scad>;
include <config.scad>

module slide_hole(radius, length, depth) { 
	translate([-radius, -length / 2 + radius, 0]) union () {
		cube([radius * 2, length - 2 * radius, depth]);
		translate([radius, 0, 0]) cylinder(depth, radius, radius);
		translate([radius, length - 2 * radius, 0]) cylinder(depth, radius, radius);
	}
}

module hole() {
	slide_hole(mount_hole_diameter / 2, hole_length, base_thickness);
	inset = 3;
	translate([0, 0, base_thickness - base_thickness / 3]) slide_hole(mount_hole_diameter / 2  + inset, hole_length + inset * 2, base_thickness / 3);
}


module base_half() { 	
	chamfer = 5;

	difference() {
		linear_extrude(base_thickness) {
			polygon(points=[
				[0, 0],
				[base_width / 2 - chamfer, 0],
				[base_width / 2, chamfer],
				[base_width / 2, main_base_length - chamfer],
				[base_width / 2 - chamfer, main_base_length],
				[0, main_base_length],
			]);

			translate([0, main_base_length]) {
				polygon(points=[
					[mount_hole_centre - base_leg_width / 2 - chamfer, 0],
					[mount_hole_centre - base_leg_width / 2,           chamfer],
					[mount_hole_centre - base_leg_width / 2,           base_leg_extent - chamfer],
					[mount_hole_centre - base_leg_width / 2 + chamfer, base_leg_extent],
					[mount_hole_centre + base_leg_width / 2 - chamfer, base_leg_extent],
					[mount_hole_centre + base_leg_width / 2, 	   base_leg_extent - chamfer],
					[mount_hole_centre + base_leg_width / 2,           chamfer],
					[mount_hole_centre + base_leg_width / 2 + chamfer, 0],
				]);
			}
		}

		translate([mount_hole_centre, main_base_length + base_leg_extent / 2]) hole();

		translate([0, main_base_length / 2 - frame_height / 2, base_thickness / 2]) 
			cube([stand_width / 2, frame_height, base_thickness / 2]);
	}
}

module base() { 
	base_half();
	mirror([-1, 0, 0]) base_half();

}

base();
