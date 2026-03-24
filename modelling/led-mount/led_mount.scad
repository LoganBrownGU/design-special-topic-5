include <config.scad>
use <pinhole_insert.scad>

module led_mount() {
    difference() {
        linear_extrude(led_mount_thickness) difference() {
            square(2 * radius_pinhole);
            translate([radius_pinhole - switch_width / 2, radius_pinhole]) square([switch_width, switch_height]);
        }
        
        translate([radius_pinhole - led_board_width / 2, radius_pinhole - led_board_height + switch_height - 2.1, led_mount_thickness - led_board_thickness]) 
            cube([led_board_width, led_board_height, led_board_thickness]);
            
        translate([radius_pinhole, radius_pinhole, led_mount_thickness - pinhole_insert_insert_depth])
            pinhole_insert();
            
        translate([radius_pinhole, radius_pinhole * 2, led_mount_thickness / 2]) rotate([90, 0, 0]) cylinder(bolt_insert_depth, bolt_insert_radius, bolt_insert_radius);
    }
}

led_mount();
