include <config.scad>


module bolt_mount() {
	difference() {
		linear_extrude(bolt_hex_length + bolt_cap + laser_inset) hexagon(bolt_mount_width);	
		linear_extrude(bolt_hex_length)            hexagon(bolt_hex_width);
	}
	
	translate([0, 0, bolt_hex_length + bolt_cap + laser_inset]) cylinder(bolt_insert_depth, bolt_insert_radius, bolt_insert_radius);
}

bolt_mount();
