using Toybox.Graphics;
using Toybox.Lang;
using Toybox.Math;
using Toybox.System;

module FilledArc {

    function drawArc(dc, value, cxcyradius, arcCenterarcExtent, thickness, outlineColor, filledColor, unfilledColor, direction) {
    	
    	var cx = cxcyradius[0];
    	var cy = cxcyradius[1];
    	var radius = cxcyradius[2];
    	var arcCenter = arcCenterarcExtent[0];
    	var arcExtent = arcCenterarcExtent[1];
    	
    	var directionFactor = (direction == Graphics.ARC_CLOCKWISE? -1: 1);
    	var startAngle = (arcCenter - directionFactor * arcExtent / 2) % 360;
    	var midAngle = (startAngle + directionFactor * arcExtent * (value / 100.0)).toNumber() % 360;
 		var endAngle = (startAngle + directionFactor * arcExtent) % 360;

	
        dc.setColor(outlineColor, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(thickness);
        dc.drawArc(cx, cy, radius, direction, startAngle - directionFactor, endAngle + directionFactor);
        dc.setPenWidth(thickness - 2);
        if (startAngle != midAngle) {
        	dc.setColor(filledColor,Graphics.COLOR_TRANSPARENT);
        	dc.drawArc(cx, cy, radius, direction, startAngle, midAngle);
        }
        if (midAngle != endAngle) {
        	dc.setColor(unfilledColor, Graphics.COLOR_TRANSPARENT);
        	dc.drawArc(cx, cy, radius, direction, midAngle, endAngle);
        } 
    }
}