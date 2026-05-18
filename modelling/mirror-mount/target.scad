include <config.scad>

mirror_radius_t = mirror_radius * 1.01;

module outer_race(thickness) {
	linear_extrude(thickness) difference() {
		circle(mirror_radius_t + target_thickness);
		circle(mirror_radius_t);
	}
}

module spokes(thickness) {
	angle_offset = 360 / 3;
	for (angle = [angle_offset:angle_offset:360]) {
		rotate([0, 0, angle]) translate([mirror_radius_t / 2, 0]) linear_extrude(thickness) square([mirror_radius_t + target_thickness * 2, 70], true);
	}
}

module target() {
	
	intersection() {
		outer_race(target_thickness * 2);
		spokes(target_thickness * 2);
	}

	difference() {
		spokes(target_thickness); 
		cylinder(10, r=1);  
	}

	
}

target();
