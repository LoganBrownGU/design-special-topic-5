include <config.scad>
module pinhole_insert() {
    difference() {
        linear_extrude(pinhole_insert_height) difference() {
            circle(radius_pinhole);
            circle(radius_pinhole - pinhole_insert_thickness);
        }
        
        translate([radius_pinhole - pinhole_insert_thickness * 1.5, 0, pinhole_insert_height / 2]) rotate([0, 90, 0])
            cylinder(pinhole_insert_thickness * 2, 2, 2);
    }
}

pinhole_insert();
