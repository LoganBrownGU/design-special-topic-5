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
			scale([+1, 1]) translate(slide_rails_offset) square([slide_thickness, slide_length], true);
			scale([-1, 1]) translate(slide_rails_offset) square([slide_thickness, slide_length], true);
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
        translate(flue_middle_to_upper_inset_offset) 
            scale(0.99) square([flue_middle_to_upper_inset_width, flue_middle_to_upper_inset_thickness], true); 
    }
}

module marks() {
	to_floor = -(slide_height - 2 * slide_rails_depth);
	mark_width = (slide_mount_width + slide_mount_wall_thickness - flue_lip_breadth) / 4;
	translate([slide_mount_width / 2, slide_mount_width / 2, to_floor + flue_lip_length]) rotate([0, 0, 90]) linear_extrude(1) square([0.5, mark_width]);
	translate([-(slide_mount_width) / 2 + mark_width, slide_mount_width / 2, to_floor + flue_lip_length]) rotate([0, 0, 90]) linear_extrude(1) square([0.5, mark_width]);
}

module lip_guard() {

	to_floor = -(slide_height - 2 * slide_rails_depth);
	cutout_length = flue_lip_cutout_length - (to_floor + flue_lip_length); 
	linear_extrude (flue_lip_guard_thickness) hull() {
		square([1, bolt_radius * 2], true);
		translate([cutout_length, 0]) circle(bolt_radius);
	}
}

module flue_upper() {
	difference() {
		upper();
		translate([0, slide_mount_width / 2 + 1, flue_upper_height / 2]) rotate([90, 0, 0]) cylinder(slide_mount_wall_thickness + 2, bolt_radius, bolt_radius); 
		translate([0, slide_mount_width / 2 - slide_mount_wall_thickness + nut_depth / 2, flue_upper_height / 2]) rotate([90, 0, 0]) hull() nut_mount();
		translate([-flue_lip_breadth / 2, slide_mount_width / 2 - flue_slit_offset - flue_slit_depth, 0]) { 
		    cube([flue_lip_breadth, slide_mount_wall_thickness, flue_upper_height]);
			cube([flue_lip_breadth + slide_thickness * 2, slide_mount_wall_thickness, slide_rails_depth]);
		}
	}
	translate([0, slide_mount_width / 2 - slide_mount_wall_thickness + nut_depth / 2, flue_upper_height / 2]) rotate([90, 0, 0]) nut_mount();
	
	translate([0, 0, flue_upper_height]) pipe_interface();
	
	
	scale([1, 1, -1]) insert_to_middle();

	marks();
	
	translate([0, (slide_mount_width - slide_mount_wall_thickness) / 2 - flue_lip_guard_thickness - 0.1]) rotate([0, 90, 90]) color("red") lip_guard();
}

flue_upper();
