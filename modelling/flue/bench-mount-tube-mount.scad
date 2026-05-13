include <config.scad>
use <blower-mount.scad>

module tube_mount() {
	offset_z = blower_upper_depth + thread_pitch * (thread_turns + 0.5);
	lead_in = 20;
	tube_radius = 25;
	inner_radius = blower_inner_radius;
		
	rotate([180, 0]) translate([0, 0, -offset_z]) blower_upper();
		
	difference() {
		linear_extrude(offset_z + lead_in) difference() {
			circle(tube_radius);
			circle(inner_radius);
		}
		hull() {
			translate([0, 0, offset_z]) linear_extrude(1) { circle(inner_radius); }		
			translate([0, 0, offset_z + lead_in]) linear_extrude(1) { circle(tube_radius); }			
		}
	}
}

tube_mount();
