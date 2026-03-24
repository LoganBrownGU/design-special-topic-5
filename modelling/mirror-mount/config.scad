$fn = $preview ? 32 : 256;

function triangle_points(side_length) = [
	[-side_length / 2, -side_length * tan(30) / 2],
	[side_length / 2, -side_length * tan(30) / 2],
	[0, side_length / (2 * cos(30))],
];



pitch = 25;

mount_point_distance = 116;
mount_hole_diameter = 6; 

frame_width = 25;
frame_height = 16.5 / 2;
frame_side_length_diff = frame_width * cos(30) / cos(60);
stand_width = mount_point_distance + (frame_width * cos(30) / cos(60));
stand_height = 55;
cutout_width = stand_width / 1.7;
cutout_height = stand_height / 1.2;


base_thickness = frame_height;
base_width = stand_width + frame_height * 2;
base_leg_extent = 120;
base_leg_width  = 4 * mount_hole_diameter;
mount_hole_centre = 1 * pitch;
hole_length = base_leg_extent / 1.2;
main_base_length = 3.5 * frame_height;
sleeve_thickness = 5;
sleeve_height = 15;

inset_depth = 0.5;
