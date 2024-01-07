import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;
import Toybox.Math;
import Toybox.ActivityMonitor;
import Toybox.Time;
import Toybox.Time.Gregorian;

class epixFaceView extends WatchUi.WatchFace {

	protected var width as Number = 0;
	protected var height as Number = 0;
    protected var onLowPower as Boolean = false;

    protected var font as FontReference;
    protected var icons as FontReference;

    function initialize() {
        WatchFace.initialize();
        // Fonts can be loaded here
        font = WatchUi.loadResource(@Rez.Fonts.id_medium_custom_digits) as FontReference;
        icons = WatchUi.loadResource(@Rez.Fonts.id_custom_icons) as FontReference;
    }

    // Load your resources here
    function onLayout(dc) {

        width = dc.getWidth();
        height = dc.getHeight();
    }


    // The user has just looked at their watch and is going into high power mode. Timers and animations may be started here.
    function onExitSleep() {
        onLowPower = false;
        requestUpdate();
    }

    // Terminate any active timers and prepare for slow updates. Watch going into low power mode
    function onEnterSleep() {
        onLowPower = true;
        requestUpdate();
    }

    // Update the view
    function onUpdate(dc) as Void {
        var canBurnIn=System.getDeviceSettings().requiresBurnInProtection;
        var cx = width / 2.0;
        var cy = height / 2.0;
        var aod = onLowPower && canBurnIn;

        // Clear all
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
		dc.clear();
        dc.setAntiAlias(true);

        // Draw the analog watch
        var aw = new AnalogWatch();
        aw.drawTicks(dc, width, height, onLowPower, canBurnIn);

        // Draw Data Fields
        var dataFields = new DataFields(width, height);
        dataFields.draw(dc, onLowPower, canBurnIn, icons);

        // Draw the digital watch
        var clockTime = System.getClockTime();
        var hourString = Lang.format("$1$", [clockTime.hour == 12? 12: clockTime.hour %12]);
        var minuteString = ('A'.toNumber() + Math.floor(clockTime.min / 10)).toNumber().toChar() + ('A'.toNumber() + clockTime.min % 10).toChar();

        var l1 = dc.getTextWidthInPixels(hourString, font);
        var l2 = dc.getTextWidthInPixels(minuteString, font);
        var lhalf = ((l1 + l2 + 4)/2).toNumber();
        dc.setColor(aod? Graphics.COLOR_LT_GRAY: 0xFF0000, Graphics.COLOR_BLACK);
	    dc.drawText(cx - (lhalf - l1), cy + 0.30 * height, font, hourString, Graphics.TEXT_JUSTIFY_RIGHT);
        dc.setColor(aod? Graphics.COLOR_LT_GRAY: Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
	    dc.drawText(cx + (lhalf - l2), cy + 0.30 * height, font, minuteString, Graphics.TEXT_JUSTIFY_LEFT);

        // Draw the analog watch
        aw.drawHands(dc, width, height, onLowPower, canBurnIn);

    }




    // function drawBattery(dc as Dc, stats as Stats, xStart as Number, yStart as Number) as Void {
    //     var bateria = stats.battery;
    //     //datos x-y para inicio y dibujo
    //     var width = dc.getTextWidthInPixels("100", Graphics.FONT_XTINY) + 4;
    //     var height = dc.getFontHeight(Graphics.FONT_XTINY) + 0;
        
    //     // Dibujo bateria
    //     dc.setPenWidth(1);
    //     dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    //     dc.drawRectangle(xStart, yStart, width, height);

    //     var xKnob = xStart + width + 1;
    //     dc.drawLine(xKnob, yStart + 4, xKnob, yStart + 12);

    //     // Porcentaje bateria
    //     if (bateria >= 70) {
    //         dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
    //     } else if (bateria >= 50) {
    //         dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
    //     }  else if (bateria >= 30) {
    //         dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);
    //     } else {
    //         dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
    //     }
    //     dc.fillRectangle(xStart + 1, yStart + 1, (width - 2) * bateria / 100, height - 2);
    //     var myBateria;
    //     //var bateriaFont = WatchUi.loadResource(Rez.Fonts.numeros2);
    //     myBateria = new WatchUi.Text({
    //         :text=>bateria.format("%d"),
    //         :color=>Graphics.COLOR_WHITE,
    //         :font=>Graphics.FONT_XTINY,
    //         :justification=>Graphics.TEXT_JUSTIFY_CENTER,
    //         :locX =>xStart+width/2,
    //         :locY=>yStart-1
    //     });
    //     myBateria.draw(dc);
    // }

    // // Update the view
    // function onUpdate(dc) as Void {

    //     dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
	// 	dc.clear();

    //     var aw = new AnalogWatch();
    //     aw.draw(dc, width, height);


        // // Get and show the current time
        // var clockTime = System.getClockTime();
        // var hourString = Lang.format("$1$", [clockTime.hour == 12? 12: clockTime.hour %12]);
        // var minuteString = ('A'.toNumber() + Math.floor(clockTime.min / 10)).toNumber().toChar() + ('A'.toNumber() + clockTime.min % 10).toChar();

        // dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
		// dc.clear();
        // dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        // var l1 = font == null? 10:  dc.getTextWidthInPixels(hourString, font);
        // var l2 = font == null? 10:  dc.getTextWidthInPixels(minuteString, font);
        // var lhalf = ((l1 + l2 + 4)/2).toNumber();
        
        // if (font != null) {
		//     dc.drawText(cx - (lhalf - l1), cy, font, hourString, Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
        // }
        // dc.setColor(Graphics.COLOR_DK_BLUE, Graphics.COLOR_WHITE);
        // if (font != null) {
		//     dc.drawText(cx + (lhalf - l2), cy, font, minuteString, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
        // }
		// // Draw date
        // dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
		// var date = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
		// dc.drawText(cx+lhalf-10, cy+50, Graphics.FONT_TINY, Lang.format("$1$ $2$", [date.day_of_week, date.day]), Graphics.TEXT_JUSTIFY_RIGHT);
		
		// // Draw heart rate
		// var heartRate = "--";
		// var hrIter = ActivityMonitor.getHeartRateHistory(3, true);
        // var hr = hrIter.next();
		// while (hr != null) {
        //     var heartRateValue = hr.heartRate;
    	// 	if (heartRateValue != null) {
        //         if (heartRateValue != ActivityMonitor.INVALID_HR_SAMPLE && heartRateValue > 0) {
		//     		heartRate = heartRateValue.toString();
		// 	    	break;
        //         }
        //     }
		// 	hr = hrIter.next();
		// }
       	// dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
		// dc.drawText(cx+lhalf-10, cy-75, Graphics.FONT_TINY, heartRate, Graphics.TEXT_JUSTIFY_RIGHT);
        // var hrW = dc.getTextWidthInPixels(heartRate, Graphics.FONT_TINY);
        // if (icons != null) {
		//     dc.drawText(cx+lhalf-15-hrW, cy-75, icons, "H", Graphics.TEXT_JUSTIFY_RIGHT);
        // }
		
		// // Draw battery status
        // var stats = System.getSystemStats();
        // // drawBattery(dc, stats, cx - l1, cy-75);
        // var battery = Math.floor(stats.battery).toNumber();
    	// FilledArc.drawArc(dc, battery, [cx, cy, cy-20], [90, 45], 7, Graphics.COLOR_LT_GRAY, 
    	// 	(battery<20? Graphics.COLOR_RED: (battery<50? Graphics.COLOR_BLUE: Graphics.COLOR_GREEN)), Graphics.COLOR_WHITE, Graphics.ARC_CLOCKWISE);
        // dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        // if (icons != null) {
		//     dc.drawText(cx-50, cy-95, icons, "B", Graphics.TEXT_JUSTIFY_RIGHT);
        // }
		// dc.drawText(cx-45, cy-95, Graphics.FONT_TINY, Lang.format("$1$", [battery]), Graphics.TEXT_JUSTIFY_LEFT);

		// // Draw steps
		// var info = ActivityMonitor.getInfo();
        // var info_steps = info.steps == null? 0: info.steps as Number;
        // var info_stepGoal = info.stepGoal == null? 1: info.stepGoal as Number;
		// var stepsSoFar = info_stepGoal <= 0? 0: info_steps * 1000.0 / info_stepGoal;

		// stepsSoFar = stepsSoFar > 100.0? 100.0: stepsSoFar;
    	// FilledArc.drawArc(dc, stepsSoFar, [cx, cy, cy-20], [270, 45], 7, Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK, Graphics.COLOR_WHITE, Graphics.ARC_COUNTER_CLOCKWISE);
        // dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        // if (icons != null) {
		//     dc.drawText(cx-50, cy+70, icons, "S", Graphics.TEXT_JUSTIFY_RIGHT);
        // }
		// dc.drawText(cx-45, cy+70, Graphics.FONT_TINY, Lang.format("$1$", [info.steps]), Graphics.TEXT_JUSTIFY_LEFT);
		
        // // https://github.com/cliffordoravec/all-the-small-things
    // }

}
