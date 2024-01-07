import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;

class AnalogWatch {

function getCoords(
	angle as Float,
	centerPoint as Array<Float>,
	centerRadius as Number,
	handLength as Number,
	tailLength as Number,
	width as Number,
	tailWidth as Number,
	triangleLength as Number) 
as Array<Array<Float>> {
	// Map out the coordinates of the watch hand (pointing down)
	var coords = [
		[-(tailWidth / 2), -centerRadius],
		[-(tailWidth / 2), -tailLength],
		[-(width / 2), -tailLength],
		[-(width / 2), -handLength],
		[0,-handLength - triangleLength],
		[width / 2, -handLength],
		[width / 2, -tailLength],
		[tailWidth / 2, -tailLength],
		[tailWidth / 2, -centerRadius],
	] as Array<Array<Float>>;

	// Transform the coordinates
	var cos = Math.cos(angle);
	var sin = Math.sin(angle);
	var result = new Array<Array<Float>>[coords.size()];
	for (var i = 0; i < coords.size(); i += 1) {
		var x = (coords[i][0] * cos) - (coords[i][1] * sin) + 0.5;
		var y = (coords[i][0] * sin) + (coords[i][1] * cos) + 0.5;

		result[i] = [centerPoint[0] + x, centerPoint[1] + y];
	}

	return result;
}


// Draw analog watch elements
function drawHands(dc as Dc, width as Number, height as Number, onLowPower as Boolean, canBurnIn as Boolean) as Void {
	var clockTime = System.getClockTime();
	var screenCenterPoint = [width/2.0, height/2.0] as Array<Float>;
        var aod = onLowPower && canBurnIn;


	// Draw hour hand
	var angle = Math.PI/6*(1.0*clockTime.hour+clockTime.min/60.0);
	var handLength = 140;
	var handWidth = 22;
	var tailLength = 30;
	var tailWidth = 6;
	var triangleLength = 14;
	var centerCircleRadius = 5;

	var color = Graphics.COLOR_BLACK;
	var coords = getCoords(angle, screenCenterPoint, centerCircleRadius, handLength+2, tailLength, handWidth+2, tailWidth+2, triangleLength);
	dc.setColor(color, Graphics.COLOR_TRANSPARENT);
	dc.fillPolygon(coords);

	color = Graphics.COLOR_LT_GRAY;
    // color = aod? Graphics.COLOR_LT_GRAY: 0xFF0000;
	coords = getCoords(angle, screenCenterPoint, centerCircleRadius, handLength, tailLength, handWidth, tailWidth, triangleLength);
	dc.setColor(color, Graphics.COLOR_TRANSPARENT);
	dc.fillPolygon(coords);

	// color = Graphics.COLOR_BLACK;
    color = aod? Graphics.COLOR_BLACK: 0xFF0000;
	coords = getCoords(angle, screenCenterPoint, centerCircleRadius, handLength-6, tailLength+6, handWidth-8, tailWidth-6, triangleLength-3);
	dc.setColor(color, Graphics.COLOR_TRANSPARENT);
	dc.fillPolygon(coords);

	// Draw minute hand
	angle = (clockTime.min / 30.0) * Math.PI;
	handLength = 184;
	handWidth = 16;
	tailLength = 30;
	tailWidth = 6;
	centerCircleRadius = 9;

	color = Graphics.COLOR_BLACK;
	coords = getCoords(angle, screenCenterPoint, centerCircleRadius, handLength+2, tailLength, handWidth+2, tailWidth+2, triangleLength);
	dc.setColor(color, Graphics.COLOR_TRANSPARENT);
	dc.fillPolygon(coords);

	color = Graphics.COLOR_LT_GRAY;
	// color = aod? Graphics.COLOR_LT_GRAY: Graphics.COLOR_BLUE;
	coords = getCoords(angle, screenCenterPoint, centerCircleRadius, handLength, tailLength, handWidth, tailWidth, triangleLength);
	dc.setColor(color, Graphics.COLOR_TRANSPARENT);
	dc.fillPolygon(coords);

	// color = Graphics.COLOR_BLACK;
	color = aod? Graphics.COLOR_BLACK: Graphics.COLOR_BLUE;
	coords = getCoords(angle, screenCenterPoint, centerCircleRadius, handLength-6, tailLength+6, handWidth-8, tailWidth-6, triangleLength-3);
	dc.setColor(color, Graphics.COLOR_TRANSPARENT);
	dc.fillPolygon(coords);

	// Draw center circle
	var centerCircleColor = Graphics.COLOR_DK_GRAY;
	centerCircleRadius = 9;
	dc.setColor(centerCircleColor, Graphics.COLOR_TRANSPARENT);
	dc.fillCircle(screenCenterPoint[0], screenCenterPoint[1], centerCircleRadius);
	centerCircleColor = Graphics.COLOR_LT_GRAY;
	centerCircleRadius = 6;
	dc.setColor(centerCircleColor, Graphics.COLOR_TRANSPARENT);
	dc.fillCircle(screenCenterPoint[0], screenCenterPoint[1], centerCircleRadius);


}

function drawTicks(dc as Dc, width as Number, height as Number, onLowPower as Boolean, canBurnIn as Boolean) as Void {
	// Draw ticks
	dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
	dc.setPenWidth(3);
	var outerRad = width / 2;
	var innerRad = outerRad - 10;			
	for (var minute = 0; minute < 60; minute += 1) {
		var angle = minute * Math.PI / 30;
		var sY = (minute % 5 == 0? innerRad - 10: innerRad) * Math.sin(angle);
		var eY = outerRad * Math.sin(angle);
		var sX = (minute % 5 == 0? innerRad - 10: innerRad) * Math.cos(angle);
		var eX = outerRad * Math.cos(angle);							
		dc.setPenWidth((minute %5 == 0)? 5: 3);
		dc.drawLine(sX + outerRad, sY + outerRad, eX + outerRad, eY + outerRad);
	}
}

}