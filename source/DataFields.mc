import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;
import Toybox.System;

class BatteryField {

    function initialize() {
    }

    function draw(dc as Dc, stats as Stats, center as Array<Number>, onLowPower as Boolean, canBurnIn as Boolean) as Void {
		var battery = Math.ceil(stats.battery);

        // Battery color
        var batteryColor = Graphics.COLOR_LT_GRAY;
        if (battery < 20) {
            batteryColor = 0xFF5555; // Pastel red
        }
        else if (battery < 40) {
            batteryColor = 0xFFFF55;  // Pastel yellow
        }
        else {
            batteryColor = 0x55FF55;  // Green
        }

        // Battery icon
        var battW = 57;  // width * 0.135
        var battH = 26;  // height * 0.0625
        var contactW = 6;  // width * 0.018
        var contactH = 16;  // height * 0.039
        dc.setColor(batteryColor, Graphics.COLOR_TRANSPARENT); 
        var xStart = center[0] - (battW + 1 + contactW)/2;
        var yStart = center[1] - battH/2;
		dc.fillRoundedRectangle(xStart, yStart, battW, battH, 2);
		dc.fillRoundedRectangle(xStart + battW + 1, yStart + (battH - contactH) / 2 , contactW, contactH, 2);
        if (onLowPower && canBurnIn) {
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT); 
    		dc.fillRoundedRectangle(xStart+1, yStart+1, battW-2, battH-2, 2);
	    	dc.fillRoundedRectangle(xStart + battW + 2, yStart + (battH - contactH) / 2 + 1 , contactW-2, contactH-2, 2);
        }

        dc.setColor(onLowPower && canBurnIn? batteryColor: Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        var battText = battery.format("%d") + "%";
        if (stats has :batteryInDays && stats.battery >20) {
            battText = stats.batteryInDays.format("%d") + "d";
        }
        dc.drawText(xStart + battW/2, center[1], Graphics.FONT_XTINY, battText, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

    }

}


class BatteryField2 {

    function initialize() {
    }

    function draw(dc as Dc, stats as Stats, center as Array<Number>, w as Number, h as Number, angle as Float, onLowPower as Boolean, canBurnIn as Boolean, icons as FontReference) as Void {
		var battery = Math.ceil(stats.battery);
        var aod = onLowPower && canBurnIn;

        // Battery color
        var batteryColor = aod? Graphics.COLOR_LT_GRAY:
            (battery < 20? 0xFF5555:
                (battery < 40? 0xFFFF55: 0x55FF55));

    	FilledArc.drawArc(dc, battery, [w/2, h/2, h/2 -20], [angle, 45], 7, 
        Graphics.COLOR_LT_GRAY, batteryColor, Graphics.COLOR_BLACK, Graphics.ARC_CLOCKWISE);
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
	    dc.drawText(center[0], center[1], icons, "B", Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
        var battText = battery.format("%d") + "%";
        if (stats has :batteryInDays && stats.battery >20) {
            battText = stats.batteryInDays.format("%d") + "d";
        }
		dc.drawText(center[0]+6, center[1], Graphics.FONT_TINY, battText, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);

    }
}


class HeartRateField {
    function initialize() {
    }

    function draw(dc as Dc, center as Array<Number>, onLowPower as Boolean, canBurnIn as Boolean, icons as FontReference) as Void {
		var heartRate = "--";
		var hrIter = ActivityMonitor.getHeartRateHistory(3, true);
        var hr = hrIter.next();
		while (hr != null) {
            var heartRateValue = hr.heartRate;
    		if (heartRateValue != null) {
                if (heartRateValue != ActivityMonitor.INVALID_HR_SAMPLE && heartRateValue > 0) {
		    		heartRate = heartRateValue.toString();
			    	break;
                }
            }
			hr = hrIter.next();
		}
       	dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
		dc.drawText(center[0], center[1], icons, "H", Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center[0]-6, center[1], Graphics.FONT_SMALL, heartRate, Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}


class DateField {
    function initialize() {
    }

    function draw(dc as Dc, center as Array<Number>, onLowPower as Boolean, canBurnIn as Boolean) as Void {
        var info = Time.Gregorian.info(Time.now(), Time.FORMAT_LONG);
        var dateStr = Lang.format("$1$, $2$ $3$", [info.day_of_week, info.month, info.day]);
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(center[0], center[1], Graphics.FONT_SMALL, dateStr, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}


class StepField {
    function initialize() {
    }

    function draw(dc as Dc, center as Array<Number>, w as Number, h as Number, angle as Float, onLowPower as Boolean, canBurnIn as Boolean, icons as FontReference) as Void {
        var aod = onLowPower && canBurnIn;
		var info = ActivityMonitor.getInfo();
        var info_steps = info.steps == null? 0: info.steps as Number;
        var info_stepGoal = info.stepGoal == null? info_steps: info.stepGoal as Number;
		var stepsSoFar = info_stepGoal <= 0? 0: info_steps * 1000.0 / info_stepGoal;
        stepsSoFar = stepsSoFar > 100.0? 100.0: stepsSoFar;

        // step color
        var stepColor = aod? Graphics.COLOR_LT_GRAY:
            (stepsSoFar < 20? 0xFF5555:
                (stepsSoFar < 40? 0xFFFF55: 0x55FF55));

    	FilledArc.drawArc(dc, stepsSoFar, [w/2, h/2, h/2-20], [angle, 45], 7, 
        Graphics.COLOR_DK_GRAY, stepColor, Graphics.COLOR_BLACK, Graphics.ARC_COUNTER_CLOCKWISE);
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
	    dc.drawText(center[0], center[1], icons, "S", Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
		dc.drawText(center[0]+2, center[1], Graphics.FONT_TINY, Lang.format("$1$", [info.steps]), Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
    }
}


// Draw data fields centered on a circle, position indicated by an hour number
class DataFields {
    var width as Number;
    var height as Number;

    function initialize(w as Number, h as Number) {
        width = w;
        height = h;
    }

    function getFieldCenter(hour as Number, width as Number, height as Number, factor as Float) as Array<Number> {
	    var angle = hour == 0? 0: (Math.PI/6.0)*hour;
        var dx = 0;
        var dy = -factor * height;
	    var cos = Math.cos(angle);
	    var sin = Math.sin(angle);
        var x = ((dx * cos) - (dy * sin) + (width / 2)).toNumber();
		var y = ((dx * sin) + (dy * cos) + (height / 2)).toNumber();
        return [x, y] as Array<Number>;
    }

    function draw(dc as Dc, onLowPower as Boolean, canBurnIn as Boolean, icons as FontReference) as Void {
        var stats = System.getSystemStats();
        // var batt = new BatteryField();
        // batt.draw(dc, stats, getFieldCenter(4, width, height, 0.4), onLowPower, canBurnIn);
        var batt2 = new BatteryField2();
        batt2.draw(dc, stats, getFieldCenter(10, width, height, 0.4), width, height, 150.0,  onLowPower, canBurnIn, icons);
        var hr = new HeartRateField();
        hr.draw(dc, getFieldCenter(4, width, height, 0.4), onLowPower, canBurnIn, icons);
        var dt = new DateField();
        dt.draw(dc, getFieldCenter(12, width, height, 0.4), onLowPower, canBurnIn);
        var st = new StepField();
        st.draw(dc, getFieldCenter(8, width, height, 0.4), width, height, 210.0, onLowPower, canBurnIn, icons);
    }
}
