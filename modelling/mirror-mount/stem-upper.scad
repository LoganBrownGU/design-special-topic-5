include <config.scad>

// stem
module stem_upper() {
	cube([stem_width, stem_width, stem_length / 2]);
};


stem_upper();
