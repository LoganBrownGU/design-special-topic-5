include <config.scad>

module beam_splitter() {
    color("aqua") cube(BEAM_SPLITTER_WIDTH, true);
}

module target() {
    linear_extrude(HOLDER_THICKNESS / 2) difference() {
        square([BEAM_SPLITTER_WIDTH - HOLDER_THICKNESS, BEAM_SPLITTER_WIDTH], true);
        circle(d=1);
    }
}

// beam_splitter();
target();
