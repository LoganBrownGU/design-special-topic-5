$fn = 128;


module hexagon(width) {
	diagonal = width * tan(30) + (width / 2) / cos(30);
	polygon(points = [
		[0, diagonal / 2],
		[width / 2,  width * tan(30) / 2],
		[width / 2, -width * tan(30) / 2],
		[0, -diagonal / 2],
		[-width / 2, -width * tan(30) / 2],
		[-width / 2,  width * tan(30) / 2],
	]);
}

switch_width = 14.5;
switch_height = 8;

bolt_hole_radius = 2.05;

bolt_hex_width = 8.3;
bolt_hex_length = 20;
bolt_mount_thickness = 3; 
bolt_mount_width = bolt_hex_width + bolt_mount_thickness * 2;
bolt_cap = 3;

laser_inset = 10;

radius_pinhole = 12.5;
pinhole_insert_thickness = 3.5;
pinhole_insert_height = 15;
pinhole_insert_insert_depth = 3;

led_mount_thickness = 15;
led_board_thickness = 5.5;
led_board_width = 11;
led_board_height = 16;

bolt_insert_radius = led_mount_thickness / 3 - pinhole_insert_insert_depth;
bolt_insert_depth = 3;
