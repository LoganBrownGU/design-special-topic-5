include <config.scad>

use <clip.scad>
use <hexagon.scad>


module pipe_interface_int() {
	hull() {
		linear_extrude(1) 
			square([slide_mount_width - 2 * slide_mount_wall_thickness, slide_mount_width - 2 * slide_mount_wall_thickness], true);
		translate([0, 0, flue_taper_into_pipe]) linear_extrude(1)
			circle(pipe_inner_radius);
	}
}

module pipe_interface_ext() {
	hull() {
		linear_extrude(1) 
			square([slide_mount_width, slide_mount_width], true);
		translate([0, 0, flue_taper_into_pipe]) linear_extrude(1)
			circle(pipe_outer_radius + pipe_seat_thickness);
	}
}

module pipe_interface() {
	difference() {
		pipe_interface_ext();
		pipe_interface_int();
	}
	
	translate([0, 0, flue_taper_into_pipe]) linear_extrude(pipe_seat_depth) difference() {
		circle(pipe_outer_radius + pipe_seat_thickness);
		circle(pipe_outer_radius);
	}
}

module flue_posts() {
	wall_center = (slide_mount_width - slide_mount_wall_thickness) / 2;
	rotate([0, 180, 0]) linear_extrude(flue_post_height) translate([0, wall_center]) { 
		translate([ wall_center, 0]) square([slide_mount_wall_thickness, slide_mount_wall_thickness], true); 
		translate([-wall_center, 0]) square([slide_mount_wall_thickness, slide_mount_wall_thickness], true); 
	} 
}

module flue_rail() {
	length = flue_post_height + flue_upper_height;
	linear_extrude(flue_lip_rail_thickness) polygon(points = [
		[0, 0],
		[length * 0.05, flue_lip_thickness],
		[length * 0.67, flue_lip_thickness],
		[length, 0]
	]);
	rotate([0, 90, 90]) translate([-(flue_lip_rail_thickness - .15), -(length - flue_lip_length - .15), flue_lip_thickness]) linear_extrude(0.4) text(">", size=2, valign="center");
}

module upper() {
	difference() {
		linear_extrude(flue_upper_height) difference() {
			square([slide_mount_width, slide_mount_width], true);
			square([slide_mount_width - 2 * slide_mount_wall_thickness, slide_mount_width - 2 * slide_mount_wall_thickness], true);
		}
		
		linear_extrude(slide_rails_depth) {
			x_offset = slide_mount_width / 2 - slide_mount_wall_thickness / 2; 
			y_offset = slide_mount_wall_thickness - (slide_mount_width - slide_length) / 2;
			translate([x_offset,  y_offset, 0]) square([slide_thickness, slide_length], true);
			translate([-x_offset, y_offset, 0]) square([slide_thickness, slide_length], true);
		}
	}
}

module nut_mount() {
	linear_extrude(nut_depth) difference() {
		hexagon(nut_width * 1.2);
		hexagon(nut_width);
	}
}

module insert_to_middle() {
    linear_extrude(flue_middle_to_upper_inset_depth) {
        translate([0, slide_mount_width / 2 - flue_middle_to_upper_inset_thickness / 2]) 
            scale(0.95) square([flue_middle_to_upper_inset_width, flue_middle_to_upper_inset_thickness], true); 
    }
}

module flue_upper() {
	difference() {
		upper();
		translate([0, slide_mount_width / 2 + 1, flue_upper_height / 2]) rotate([90, 0, 0]) cylinder(slide_mount_wall_thickness + 2, bolt_radius, bolt_radius); 
		translate([0, slide_mount_width / 2 - slide_mount_wall_thickness + nut_depth / 2, flue_upper_height / 2]) rotate([90, 0, 0]) hull() nut_mount();
	}
	translate([0, slide_mount_width / 2 - slide_mount_wall_thickness + nut_depth / 2, flue_upper_height / 2]) rotate([90, 0, 0]) nut_mount();
	
	flue_posts();
	rotate([180, 0, 0]) insert_to_middle();
	
	translate([slide_mount_width / 2 - flue_lip_rail_thickness, slide_mount_width / 2, flue_upper_height]) rotate([0, 90, 0]) 
		flue_rail();
	translate([-slide_mount_width / 2 + flue_lip_rail_thickness, slide_mount_width / 2, flue_upper_height]) rotate([0, 90, 0]) mirror([0, 0, 1])
		flue_rail();
		
	translate([0, 0, flue_upper_height]) pipe_interface();
}

flue_upper();
