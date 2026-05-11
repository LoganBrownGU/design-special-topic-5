include <config.scad>
use <blower-mount.scad>

module pipe(length) {
    linear_extrude(length) { difference() {
        circle(pipe_outer_radius);
        circle(pipe_inner_radius);
    }}
}

module vertical() {
    translate([0, 0, pipe_outer_radius + connection_depth]) pipe(bench_mount_height - connection_depth);
    translate([0, 0, bench_mount_height + blower_upper_depth * 3]) blower_upper();
}

vertical();
