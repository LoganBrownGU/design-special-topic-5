$fn = $preview ? 32 : 128;
thread_fn = $preview ? 16 : 128;

INFTSML = 0.0000000000001;

BEAM_SPLITTER_WIDTH = 25;
HOLDER_THICKNESS = 5;

BOLT_HEX_WIDTH = 8.3;
BOLT_HEX_LENGTH = 20;
BOLT_MOUNT_THICKNESS = 3;
BOLT_MOUNT_CAP = 3;

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
