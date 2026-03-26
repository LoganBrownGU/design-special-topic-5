$fn = $preview ? 32 : 128;
thread_fn = $preview ? 16 : 64;

blower_inner_radius = 41.7 / 2;
blower_lip_width = 9.5;
blower_lip_depth = 2.5;
blower_inset_depth = 2.5;
blower_inset_radius = 34 / 2;
blower_lip_thickness = 2;
blower_middle_depth = 2.5;
blower_outer_radius = 49 / 2;
blower_upper_depth = 5;

thread_size = str("M", str(floor(blower_inset_radius)), "x0.5");
