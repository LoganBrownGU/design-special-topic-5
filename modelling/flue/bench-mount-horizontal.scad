include <config.scad>
use <blower-mount.scad>

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
            translate([pipe_outer_radius, 0, -pipe_outer_radius + base_thickness/2]) rotate([0, 90]) linear_extrude(bench_mount_length * .9) square([base_thickness*1.1, 20], true);
        }
        translate([(pipe_outer_radius + bench_mount_length) / 2, 0, -bench_mount_height*2]) cylinder(bench_mount_height * 4, d=6);
    }

    translate([pipe_outer_radius + bench_mount_length + blower_middle_depth, 0]) rotate([0, -90]) { blower_lower(); blower_middle(); }
}

horizontal();
