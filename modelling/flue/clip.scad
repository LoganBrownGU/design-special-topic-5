module clip_outer(clip_depth, width, breadth) { color("red") {
    assert(width > 4 * clip_depth, "width must be greater than 4 * clip_depth");
    assert(breadth > 4 * clip_depth, "breadth must be greater than 4 * clip_depth");

    linear_extrude(clip_depth) difference()  {
        square([width, breadth], true);
        square([width - 4 * clip_depth, breadth - 4 * clip_depth], true);
    }
    
    translate([0, 0, clip_depth]) linear_extrude(clip_depth) difference()  {
            square([width, breadth], true);
            square([width - 2 * clip_depth, breadth - 2 * clip_depth], true);
    }
    
    translate([0, 0, clip_depth * 2]) linear_extrude(clip_depth) difference()  {
        square([width, breadth], true);
        square([width - 4 * clip_depth, breadth - 4 * clip_depth], true);
    }
}}


module clip_inner(clip_depth, width, breadth) { color("green") {
    assert(width > 4 * clip_depth, "width must be greater than 4 * clip_depth");
    assert(breadth > 4 * clip_depth, "breadth must be greater than 4 * clip_depth");

    linear_extrude(clip_depth) 
        square([width, breadth], true);
    
    translate([0, 0, clip_depth]) linear_extrude(clip_depth) 
        square([width - 4 * clip_depth, breadth - 4 * clip_depth], true); 
        
    translate([0, 0, clip_depth * 2]) linear_extrude(clip_depth)
        square([width - 2 * clip_depth, breadth - 2 * clip_depth], true);
}}

translate([ 10, 0, 0]) { translate([0, 0, 2]) clip_inner(0.4, 10, 10); linear_extrude(2) square([15, 15], true); }
translate([-10, 0, 0]) { translate([0, 0, 2]) clip_outer(0.4, 10, 10); linear_extrude(2) square([15, 15], true); }
