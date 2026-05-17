$fn = $preview ? 32 : 128;
thread_fn = $preview ? 16 : 128;

INFTSML = 0.0000000000001;

NOTCH_COUNT = 0;
NOTCH_WIDTH = 2;
NOTCH_DEPTH = 2;

blower_inner_radius = 43.7 / 2;
blower_lip_width = 13.5;
blower_lip_depth = 3;
blower_inset_depth = 2.5;
blower_inset_radius = 35 / 2;
blower_lip_thickness = 2;
blower_middle_depth = 4;
blower_outer_radius = 49 / 2;
blower_upper_depth = 5;

slide_height = 25;
slide_thickness = 1.4;
slide_rails_depth = 2;
slide_rails_height = slide_rails_depth * 2;
slide_rails_width = slide_thickness + 0.6;
slide_mount_wall_thickness = slide_thickness * 3.5;
slide_mount_width = 38 + slide_mount_wall_thickness * 2;
slide_length = slide_mount_width;
slide_rails_length = slide_length * 1.01;
clip_depth = 2;
flue_taper_into_slit = 20; 
flue_floor_thickness = 5;
flue_slit_depth = 1;
flue_slit_offset = flue_slit_depth * 1.5;
flue_upper_height = 20;
flue_lip_length = flue_upper_height + 15;
flue_lip_thickness = 2;
flue_lip_breadth = slide_mount_width - slide_mount_wall_thickness;
flue_slit_length = flue_lip_breadth - slide_mount_wall_thickness;
flue_lip_rail_thickness = (slide_mount_width - flue_lip_breadth) / 2;
flue_lip_cutout_length = flue_lip_length / 2;
flue_lip_guard_thickness = 1;
flue_lip_y_offset = slide_mount_width / 2 - flue_slit_offset - flue_lip_thickness / 2;
flue_post_height = slide_height - 2 * slide_rails_depth;
slide_rails_offset = [flue_lip_breadth / 2 + slide_thickness / 2, slide_mount_wall_thickness - (slide_mount_width - slide_rails_length) / 2];

flue_middle_to_upper_inset_depth = flue_post_height / 2;
flue_middle_to_upper_inset_width = slide_mount_width / 3;
flue_middle_to_upper_inset_thickness = slide_mount_wall_thickness / 2;
flue_middle_to_upper_inset_offset = [0, -(slide_mount_width / 2 - flue_middle_to_upper_inset_thickness / 2)];


nut_depth = 2.3;
nut_width = 6;
bolt_radius = 3 / 2;

pipe_outer_radius = 41 / 2;
pipe_inner_radius = 37.5 / 2;
flue_taper_into_pipe = 20;
pipe_seat_depth = 15;
pipe_seat_thickness = 2;


window_post_width = 2;
window_post_height = slide_height + clip_depth;

thread_size = "M42";
thread_turns = 2;
thread_pitch = 4.5;

bench_mount_length = 100;
bench_mount_height = 25;
connection_depth = 1;
