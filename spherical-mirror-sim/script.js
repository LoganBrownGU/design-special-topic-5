class Point {
	constructor(x, y) {
		this.x = x;
		this.y = y;
	}

	multiplyScalar(m) {
		this.x *= m
		this.y *= m
	}
};

let canvas = document.getElementById("cvs")

const displayWidth = window.screen.width - 600
const displayHeight = window.screen.height - 200

canvas.style.width = displayWidth + "px"
canvas.style.height = displayHeight + "px"
canvas.width = displayWidth
canvas.height = displayHeight
canvas.style.backgroundColor = "black"

document.onmousemove = updateSource

const ctx = canvas.getContext("2d")

const width = canvas.width
const height = canvas.height

const diameter = 400
const radiusOfCurvature = 200
const PI = 3.1415926535


let source = new Point(0, 0) 

function getTheta() {
	return Math.asin(diameter / (2*radiusOfCurvature))
}

function clear() {
	ctx.setTransform(1, 0, 0, 1, 0, 0);
	ctx.clearRect(0, 0, width, height) 
}

function doTranslation() {
	ctx.setTransform(1, 0, 0, 1, 0, 0);
	ctx.translate(width / 2, height / 2)
}

function drawMirror() {
	let theta = getTheta() 
	ctx.strokeStyle = "white"
	ctx.beginPath()
	ctx.arc(0, 0, radiusOfCurvature, -theta, theta)
	ctx.stroke()
}

function drawSource() {
	let r = 5;
	ctx.fillStyle = "white"
	ctx.beginPath()
	ctx.ellipse(source.x, source.y, r, r, 0, 0, 2*PI)
	ctx.fill()
}	

function drawRays() {
	let theta = getTheta()

	let rayPoints = []
	for (var angle = -theta; angle <= theta; angle += 2*theta/4) {
		rayPoints.push([new Point(radiusOfCurvature * Math.cos(angle), radiusOfCurvature * Math.sin(angle)), angle])
	}

	rayPoints.forEach(function ([p, a]) {
		let delta = new Point(source.x - p.x, source.y - p.y)
		delta.multiplyScalar(100)

		// draw ray 
		ctx.strokeStyle = "yellow" 
		ctx.beginPath()
		ctx.moveTo(source.x, source.y)
		ctx.lineTo(p.x, p.y)
		ctx.stroke()

		// draw reflection
		ctx.strokeStyle = "yellow" 
		ctx.beginPath()
		ctx.translate(p.x, p.y)
		ctx.rotate(a)
		ctx.moveTo(0, 0)
		ctx.lineTo(delta.x, -delta.y)
		ctx.stroke()
		doTranslation()

		/*
		// draw tangent
		ctx.strokeStyle = "blue" 
		ctx.beginPath()
		ctx.translate(p.x, p.y)
		ctx.rotate(a + PI / 2) 
		ctx.moveTo(-100, 0)
		ctx.lineTo(100, 0)
		ctx.stroke()
		doTranslation()

		// draw normal
		ctx.strokeStyle = "blue" 
		ctx.beginPath()
		ctx.moveTo(0, 0)
		ctx.lineTo(p.x, p.y)
		ctx.stroke()
		doTranslation()
		*/
	})
	
}

function updateSource(e) {
	source = new Point(e.clientX - width / 2, e.clientY - height / 2)
}

function draw() {
	clear()
	doTranslation()
	drawMirror()
	drawSource()
	drawRays()
	setTimeout(draw, 20)
}

