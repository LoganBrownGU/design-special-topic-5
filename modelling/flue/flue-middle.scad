include <config.scad>
use <slide.scad>

module clip_male() {
    linear_extrude(clip_depth) difference()  {
        square([slide_mount_width, slide_mount_width], true);
        square([slide_mount_width - 4 * clip_depth, slide_mount_width - 4 * clip_depth], true);
    }
    
    translate([0, 0, clip_depth]) linear_extrude(clip_depth) difference()  {
            square([slide_mount_width, slide_mount_width], true);
            square([slide_mount_width - 2 * clip_depth, slide_mount_width - 2 * clip_depth], true);
    }
    
    translate([0, 0, clip_depth * 2]) linear_extrude(clip_depth) difference()  {
        square([slide_mount_width, slide_mount_width], true);
        square([slide_mount_width - 4 * clip_depth, slide_mount_width - 4 * clip_depth], true);
    }
} 

module flue_posts() {
    linear_extrude(slide_height - 2 * slide_rails_depth) difference() {
        translate([-slide_mount_width / 2, -slide_mount_width / 2]) square([slide_mount_width, slide_mount_wall_thickness]);
    }
}

module slide_rails() {
    difference() {
        linear_extrude(slide_rails_height) difference() {
            square([slide_mount_width, slide_mount_width], true);
            square([slide_mount_width - 2 * slide_mount_wall_thickness, slide_mount_width - 2 * slide_mount_wall_thickness], true);
        } 
        
        translate([0, 0, slide_rails_height - slide_rails_depth]) linear_extrude(slide_rails_depth) {
            x_offset = slide_mount_width / 2 - slide_mount_wall_thickness / 2; 
            y_offset = slide_mount_wall_thickness - (slide_mount_width - slide_length) / 2;
            translate([x_offset,  y_offset, 0]) square([slide_thickness, slide_length], true);
            translate([-x_offset, y_offset, 0]) square([slide_thickness, slide_length], true);
        }
    }
   
} 

module flue_middle() {
    rotate([180, 0, 0]) clip_male();

    slide_rails();
    translate([0, 0, slide_rails_height]) flue_posts(); 
    
    // translate([0, 0, window_post_height + clip_depth * 2]) intersection () {
    //     clip_male();
    //     flue_posts(); 
    // }
}

flue_middle();
