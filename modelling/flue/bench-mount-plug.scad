include <config.scad>

module bench_mount_plug() {
    head = 1;
    length = pipe_outer_radius - pipe_inner_radius + 1;
    cylinder(head, d=8);
    cylinder(length + head, d=5);
}
bench_mount_plug();
