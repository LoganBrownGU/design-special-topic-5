
include <config.scad>


module laser_mount() {
	difference() {
		cylinder(laser_length_2, laser_sleeve_radius, laser_sleeve_radius);
		cylinder(laser_length_0, laser_radius_0, laser_radius_0);
		cylinder(laser_length_1, laser_radius_1, laser_radius_1);
		cylinder(laser_length_2, laser_radius_2, laser_radius_2);
	}
}

laser_mount();
