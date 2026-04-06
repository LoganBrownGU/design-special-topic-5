include <config.scad>
use <slide.scad>

module flue_rear() {
    translation = [-slide_mount_width / 2, -(slide_mount_width + slide_mount_wall_thickness) / 2];
    linear_extrude(flue_post_height - flue_middle_to_upper_inset_depth) translate(translation) {
        square([slide_mount_width, slide_mount_wall_thickness * 1.5]);
    }
    translate([0, 0, flue_post_height - flue_middle_to_upper_inset_depth]) linear_extrude(flue_middle_to_upper_inset_depth) translate(translation) difference() {
        square([slide_mount_width, slide_mount_wall_thickness * 1.5]);
        translate([flue_middle_to_upper_inset_width, slide_mount_wall_thickness - flue_middle_to_upper_inset_thickness]) 
            square([flue_middle_to_upper_inset_width, flue_middle_to_upper_inset_thickness]); 
    }
}

module slide_rails() {
    difference() {
        linear_extrude(slide_rails_height) difference() {
            square(slide_mount_width, true);
            inner_width = slide_mount_width - 2 * slide_mount_wall_thickness;
            square(inner_width, true);
            translate([0, inner_width / 2]) square(inner_width, true);
        } 
        
        translate([0, 0, slide_rails_height - slide_rails_depth]) linear_extrude(slide_rails_depth) {
            translate([+slide_rails_x_offset, slide_rails_y_offset, 0]) square([slide_thickness, slide_length], true);
            translate([-slide_rails_x_offset, slide_rails_y_offset, 0]) square([slide_thickness, slide_length], true);
        }
    }
} 

module attachment() {
    linear_extrude(slide_rails_height * 2) difference() {
        square(slide_mount_width + slide_mount_wall_thickness, true);
        square(slide_mount_width, true);
        translate([0, slide_mount_width / 2]) square(slide_mount_width - 2 * slide_mount_wall_thickness, true);
    }
} 

module flue_middle() {

    difference() {
        union() { slide_rails(); translate([0, 0, -slide_rails_height]) attachment(); };
        translate([0, slide_mount_width / 2, slide_rails_height - slide_rails_depth / 2]) 
            cube([slide_mount_width + 2 * slide_mount_wall_thickness, slide_mount_wall_thickness + 0.2, slide_rails_depth], true);
        translate([0, slide_mount_width / 2, (slide_rails_height - slide_rails_depth) / 2]) 
            cube([flue_lip_breadth, slide_mount_wall_thickness + 0.2, (slide_rails_height - slide_rails_depth)], true);
    }
    translate([0, 0, slide_rails_height]) flue_rear(); 
}

flue_middle();
