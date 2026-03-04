$fn = $preview ? 32 : 256;

function triangle_points(side_length) = [
	[-side_length / 2, -side_length * tan(30) / 2],
	[side_length / 2, -side_length * tan(30) / 2],
	[0, side_length / (2 * cos(30))],
];



pitch = 25;

mount_point_distance = 115.5;
mount_hole_diameter = 5; 

frame_width = 25;
frame_height = 16.5 / 2;
frame_side_length_diff = frame_width * cos(30) / cos(60);
stand_height = 55;

base_thickness = frame_height;
base_length = 180;
base_width = triangle_points(mount_point_distance + frame_side_length_diff)[1][0] * 2;

inset_depth = 0.5;
