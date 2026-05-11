include <config.scad>
use <blower-mount.scad>
use <bench-mount-vertical.scad>
use <bench-mount-horizontal.scad>
use <bench-mount-connection.scad>
use <bench-mount-plug.scad>

module body() { 
    horizontal();
    vertical();
    connection();
}

body();
translate([0, 30]) bench_mount_plug();
