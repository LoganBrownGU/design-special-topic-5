include <config.scad>
use <flue-upper.scad>


projection(true) {
	rotate([-90,90]) flue_upper();
    translate([40 + slide_mount_width/2, 0, slide_mount_width/2 - flue_lip_thickness * 1.5 ]) rotate([-90,0]) flue_upper();
}
