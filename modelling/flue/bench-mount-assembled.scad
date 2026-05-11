include <config.scad>
use <blower-mount.scad>
use <bench-mount-vertical.scad>
use <bench-mount-horizontal.scad>
use <bench-mount-connection.scad>

module body() { 
    horizontal();
    vertical();
    connection();
}

body();
