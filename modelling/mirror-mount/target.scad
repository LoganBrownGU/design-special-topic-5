include <config.scad>

mirror_radius_t = mirror_radius * 1.01;

module outer_race(thickness) {
	linear_extrude(thickness) difference() {
		circle(mirror_radius_t + target_thickness);
		circle(mirror_radius_t);
	}
}

module target() {
	angle_offset = 360 / 3;
	outer_race(target_thickness);
	difference() {
		outer_race(target_thickness * 2);
		for (angle = [angle_offset:angle_offset:360]) {
			rotate([0, 0, angle]) translate([mirror_radius_t, 0]) linear_extrude(target_thickness * 2) square([mirror_radius_t + target_thickness * 3, 70], true);
		}
	}

	
	linear_extrude(target_thickness) difference() {
		for (angle = [angle_offset:angle_offset:360]) {
			rotate([0, 0, angle]) translate([mirror_radius_t/2, 0]) square([mirror_radius_t, target_thickness], true);
		}

		circle(target_thickness/3);
	}
	
	
}

target();
