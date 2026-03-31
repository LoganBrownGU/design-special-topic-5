include <config.scad>
use <slide.scad>

module flue_posts() {
    linear_extrude(flue_post_height) {
        translate([-slide_mount_width / 2, -slide_mount_width / 2]) square([slide_mount_width, slide_mount_wall_thickness]);
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
            x_offset = slide_mount_width / 2 - slide_mount_wall_thickness / 2; 
            y_offset = slide_mount_wall_thickness - (slide_mount_width - slide_length) / 2;
            translate([x_offset,  y_offset, 0]) square([slide_thickness, slide_length], true);
            translate([-x_offset, y_offset, 0]) square([slide_thickness, slide_length], true);
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
    translate([0, 0, -slide_rails_height]) attachment();

    slide_rails();
    translate([0, 0, slide_rails_height]) flue_posts(); 
}

flue_middle();
