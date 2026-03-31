$fn = $preview ? 32 : 128;
thread_fn = $preview ? 16 : 128;

INFTSML = 0.0000000000001;

blower_inner_radius = 43.7 / 2;
blower_lip_width = 10.5;
blower_lip_depth = 2.5;
blower_inset_depth = 2.5;
blower_inset_radius = 35 / 2;
blower_lip_thickness = 2;
blower_middle_depth = 2.5;
blower_outer_radius = 49 / 2;
blower_upper_depth = 5;

slide_length = 38;
slide_height = 25;
slide_thickness = 1.4;
slide_rails_height = 3;
slide_rails_depth = slide_rails_height / 2;
slide_mount_wall_thickness = slide_thickness * 2.8;
slide_mount_width = slide_length + slide_mount_wall_thickness * 2;
clip_depth = 0.6;
flue_slit_length = slide_mount_width * 0.75;
flue_taper_into_slit = 20; 
flue_floor_thickness = slide_mount_wall_thickness;
flue_slit_depth = 1;
flue_slit_offset = slide_mount_wall_thickness + flue_slit_depth / 2;
flue_upper_height = 20;
flue_lip_length = flue_upper_height + 15;
flue_lip_thickness = 2;
flue_lip_breadth = slide_mount_width - slide_mount_wall_thickness; 
flue_lip_rail_thickness = (slide_mount_width - flue_lip_breadth) / 2;
flue_post_height = slide_height - 2 * slide_rails_depth + 4 * clip_depth;

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
