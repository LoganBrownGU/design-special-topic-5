include <config.scad>

use <clip.scad>
use <hexagon.scad>

module flue_posts() {
    wall_center = (slide_mount_width - slide_mount_wall_thickness) / 2;
    rotate([0, 180, 0]) linear_extrude(slide_height) translate([0, wall_center]) { 
        translate([ wall_center, 0]) square([slide_mount_wall_thickness, slide_mount_wall_thickness], true); 
        translate([-wall_center, 0]) square([slide_mount_wall_thickness, slide_mount_wall_thickness], true); 
    } 
    
    rotate([0, 180, 0]) translate([0, wall_center, slide_height]) { 
        translate([ wall_center, 0]) 
            clip_outer(clip_depth, slide_mount_wall_thickness, slide_mount_wall_thickness);
        translate([-wall_center, 0]) 
            clip_outer(clip_depth, slide_mount_wall_thickness, slide_mount_wall_thickness);
    }
}

module flue_rail() {
    length = slide_height + flue_upper_height;
    linear_extrude(flue_lip_rail_thickness) polygon(points = [
        [0, 0],
        [0, flue_lip_thickness],
        [length * 0.67, flue_lip_thickness],
        [length, 0]
    ]); 
}

module upper() {
    linear_extrude(flue_upper_height) difference() {
        square([slide_mount_width, slide_mount_width], true);
        square([slide_mount_width - 2 * slide_mount_wall_thickness, slide_mount_width - 2 * slide_mount_wall_thickness], true);
    }
}

module nut_mount() {
    linear_extrude(nut_depth) difference() {
        hexagon(nut_width * 1.2);
        hexagon(nut_width);
    }
}

module flue_upper() {
    difference() {
        upper();
        translate([0, slide_mount_width / 2 + 1, flue_upper_height / 2]) rotate([90, 0, 0]) cylinder(slide_mount_wall_thickness + 2, bolt_radius, bolt_radius); 
        translate([0, slide_mount_width / 2 - slide_mount_wall_thickness + nut_depth / 2, flue_upper_height / 2]) rotate([90, 0, 0]) hull() nut_mount();
    }
    translate([0, slide_mount_width / 2 - slide_mount_wall_thickness + nut_depth / 2, flue_upper_height / 2]) rotate([90, 0, 0]) nut_mount();
    
    

    translate([0, -(slide_mount_width - slide_mount_wall_thickness) / 2]) rotate([180, 0, 0])
        clip_outer(clip_depth, slide_mount_width, slide_mount_wall_thickness);

    flue_posts();
    
    translate([slide_mount_width / 2 - flue_lip_rail_thickness, slide_mount_width / 2, flue_upper_height]) rotate([0, 90, 0]) 
        flue_rail();
    translate([-slide_mount_width / 2, slide_mount_width / 2, flue_upper_height]) rotate([0, 90, 0]) 
        flue_rail();
}

flue_upper();
