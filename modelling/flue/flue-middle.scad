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
    difference() {
        cube([slide_mount_width, slide_mount_width, window_post_height + clip_depth * 3], true);
        cube([slide_mount_width - 2 * slide_mount_wall_thickness, slide_mount_width - 2 * slide_mount_wall_thickness, window_post_height + clip_depth * 3], true);
            
        translate([0, 0, 2 * clip_depth]) {
            cube([slide_mount_width, slide_mount_width - 2 * slide_mount_wall_thickness, window_post_height ], true);
            cube([slide_mount_width - 2 * slide_mount_wall_thickness, slide_mount_width, window_post_height ], true);
        }
    }
}

module flue_middle() {
    rotate([180, 0, 0]) clip_male();

    difference() {
        translate([0, 0, (window_post_height + clip_depth * 3) / 2]) flue_posts(); 
        translate([0, 0, clip_depth * 2]) { 
            translate([-slide_length / 2, slide_mount_width / 2]) rotate([90, 0, 0]) slide(); 
            translate([-slide_length / 2, -slide_mount_width / 2 + slide_thickness]) rotate([90, 0, 0]) slide(); 
            translate([-slide_mount_width / 2, -slide_length / 2]) rotate([90, 0, 90]) slide(); 
            translate([slide_mount_width / 2 - slide_thickness, -slide_length / 2]) rotate([90, 0, 90]) slide(); 
        }
    }
    
    translate([0, 0, window_post_height + clip_depth * 2]) intersection () {
        clip_male();
        flue_posts(); 
    }
}

flue_middle();
