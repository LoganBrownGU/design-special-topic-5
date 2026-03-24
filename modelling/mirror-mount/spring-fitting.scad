include <config.scad>

module spring_fitting() {
	union () {
		cylinder(1.3 + 2.6, 4.5, 4.5);
	}
}

module spring_fitting_inset() {
	difference() {
		union() {
			spring_fitting();
			translate([0, 0, -inset_depth]) cylinder(inset_depth, 6.5, 6.5); 
		}
		cylinder(1.3 + 2.6, mount_hole_diameter / 2, mount_hole_diameter / 2);
	}

}

spring_fitting_inset();
