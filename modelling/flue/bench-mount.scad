include <config.scad>
use <blower-mount.scad>

connection_depth = 1;
module pipe(length) {
    linear_extrude(length) { difference() {
        circle(pipe_outer_radius);
        circle(pipe_inner_radius);
    }}
}

module horizontal() {
    difference() {
        union() {
            translate([pipe_outer_radius, 0]) rotate([0, 90]) pipe(bench_mount_length);
            base_thickness = 4;
            translate([pipe_outer_radius, 0, -pipe_outer_radius + base_thickness/2]) rotate([0, 90]) linear_extrude(bench_mount_length) square([base_thickness, 20], true);
        }
        translate([(pipe_outer_radius + bench_mount_length) / 2, 0, -bench_mount_height*2]) cylinder(bench_mount_height * 4, d=6);
    
    }
}

module vertical() {
    translate([0, 0, pipe_outer_radius + connection_depth]) pipe(bench_mount_height - connection_depth);
    translate([0, 0, bench_mount_height + blower_upper_depth * 3]) blower_upper();
}

module connection() {
    difference() {
        hull() {
            translate([0, 0, pipe_outer_radius])              cylinder(connection_depth, r=pipe_outer_radius);
            translate([pipe_outer_radius, 0]) rotate([0, 90]) cylinder(connection_depth, r=pipe_outer_radius);
        }
        hull() {
            translate([0, 0, pipe_outer_radius])              cylinder(connection_depth, r=pipe_inner_radius);
            translate([pipe_outer_radius, 0]) rotate([0, 90]) cylinder(connection_depth, r=pipe_inner_radius); 
        }
    }
}

module body() { 
    horizontal();
    vertical();
    connection();
}

body();
