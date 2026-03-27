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
