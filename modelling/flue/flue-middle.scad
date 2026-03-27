include <config.scad>
use <slide.scad>

module clip_to_lower() {
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

module flue_middle() {
    rotate([180, 0, 0]) clip_to_lower();

    translate([0, 0, window_post_height / 2]) difference() {
        cube([slide_mount_width, slide_mount_width, window_post_height], true);
        cube([slide_mount_width - 2 * slide_mount_wall_thickness, slide_mount_width - 2 * slide_mount_wall_thickness, window_post_height], true);
            
        translate([0, 0, clip_depth]) {
            cube([slide_mount_width, slide_mount_width - 2 * slide_mount_wall_thickness, window_post_height - 2 * clip_depth], true);
            cube([slide_mount_width - 2 * slide_mount_wall_thickness, slide_mount_width, window_post_height - 2 * clip_depth], true);
        }
    }
}

flue_middle();
