include <config.scad>
use <blower-mount.scad>

module pipe(length) {
    linear_extrude(length) { difference() {
        circle(pipe_outer_radius);
        circle(pipe_inner_radius);
    }}
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

connection();
