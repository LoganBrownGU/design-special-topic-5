
use <threadlib/threadlib.scad> 
include <config.scad>


nut(thread_size, turns=thread_turns, Douter=blower_outer_radius * 2, fn=thread_fn);

translate([60, 0]) bolt(thread_size, turns=thread_turns, fn=thread_fn);
translate([-60, 0]) scale(0.99) bolt(thread_size, turns=thread_turns, fn=thread_fn);
