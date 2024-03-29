using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Math;
using Toybox.ActivityMonitor;
using Toybox.Time;
using Toybox.Time.Gregorian;

class simplefenixfaceView extends WatchUi.WatchFace {

	hidden var cx;
    hidden var cy;
    hidden var font;
    hidden var icons;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        cx = dc.getWidth() / 2;
        cy = dc.getHeight() / 2;
        font = WatchUi.loadResource(@Rez.Fonts.id_custom_digits);
        icons = WatchUi.loadResource(@Rez.Fonts.id_custom_icons);
    
//        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    function drawBattery(dc, stats, xStart, yStart) {
        var bateria = stats.battery;
        //datos x-y para inicio y dibujo
        var width = dc.getTextWidthInPixels("100", Graphics.FONT_XTINY) + 4;
        var height = dc.getFontHeight(Graphics.FONT_XTINY) + 0;
        
        // Dibujo bateria
        dc.setPenWidth(1);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawRectangle(xStart, yStart, width, height);

        var xKnob = xStart + width + 1;
        dc.drawLine(xKnob, yStart + 4, xKnob, yStart + 12);

        // Porcentaje bateria
        if (bateria >= 70) {
            dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
        } else if (bateria >= 50) {
            dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
        }  else if (bateria >= 30) {
            dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);
        } else {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        }
        dc.fillRectangle(xStart + 1, yStart + 1, (width - 2) * bateria / 100, height - 2);
        var myBateria;
        //var bateriaFont = WatchUi.loadResource(Rez.Fonts.numeros2);
        myBateria = new WatchUi.Text({
            :text=>bateria.format("%d"),
            :color=>Graphics.COLOR_WHITE,
            :font=>Graphics.FONT_XTINY,
            :justification=>Graphics.TEXT_JUSTIFY_CENTER,
            :locX =>xStart+width/2,
            :locY=>yStart-1
        });
        myBateria.draw(dc);
    }

    // Update the view
    function onUpdate(dc) as Void {
        // Get and show the current time
        var clockTime = System.getClockTime();
        var hourString = Lang.format("$1$", [clockTime.hour == 12? 12: clockTime.hour %12]);
        var minuteString = ('A'.toNumber() + Math.floor(clockTime.min / 10)).toChar() + ('A'.toNumber() + clockTime.min % 10).toChar();

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
		dc.clear();
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        var l1 = dc.getTextWidthInPixels(hourString, font);
        var l2 = dc.getTextWidthInPixels(minuteString, font);
        var lhalf = ((l1 + l2 + 4)/2).toNumber();
        
		dc.drawText(cx - (lhalf - l1), cy, font, hourString, Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.setColor(Graphics.COLOR_DK_BLUE, Graphics.COLOR_WHITE);
		dc.drawText(cx + (lhalf - l2), cy, font, minuteString, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);

		// Draw date
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
		var date = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
		dc.drawText(cx+lhalf-10, cy+50, Graphics.FONT_TINY, Lang.format("$1$ $2$", [date.day_of_week, date.day]), Graphics.TEXT_JUSTIFY_RIGHT);
		
		// Draw heart rate
		var heartRate = "--";
		var hrIter = ActivityMonitor.getHeartRateHistory(null, true);
        var hr = hrIter.next();
		while (hr != null) {
			if (hr.heartRate != ActivityMonitor.INVALID_HR_SAMPLE && hr.heartRate > 0) {
				heartRate = hr.heartRate.toString();
				break;
			}
			hr = hrIter.next();
		}
       	dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
		dc.drawText(cx+lhalf-10, cy-75, Graphics.FONT_TINY, heartRate, Graphics.TEXT_JUSTIFY_RIGHT);
		dc.drawText(cx+lhalf-15- dc.getTextWidthInPixels(heartRate, Graphics.FONT_TINY), cy-75, icons, "H", Graphics.TEXT_JUSTIFY_RIGHT);
		
		// Draw battery status
        var stats = System.getSystemStats();
        // drawBattery(dc, stats, cx - l1, cy-75);
        var battery = Math.floor(stats.battery).toNumber();
    	FilledArc.drawArc(dc, battery, [cx, cy, cy-20], [90, 45], 7, Graphics.COLOR_LT_GRAY, 
    		(battery<20? Graphics.COLOR_RED: (battery<50? Graphics.COLOR_BLUE: Graphics.COLOR_GREEN)), Graphics.COLOR_WHITE, Graphics.ARC_CLOCKWISE);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
		dc.drawText(cx-50, cy-95, icons, "B", Graphics.TEXT_JUSTIFY_RIGHT);
		dc.drawText(cx-45, cy-95, Graphics.FONT_TINY, Lang.format("$1$", [battery]), Graphics.TEXT_JUSTIFY_LEFT);

		// Draw steps
		var info = ActivityMonitor.getInfo();
		var stepsSoFar = info.stepGoal == 0? 0.0: (info.steps * 100.0) / info.stepGoal;
		stepsSoFar = stepsSoFar > 100.0? 100.0: stepsSoFar;
    	FilledArc.drawArc(dc, stepsSoFar, [cx, cy, cy-20], [270, 45], 7, Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK, Graphics.COLOR_WHITE, Graphics.ARC_COUNTER_CLOCKWISE);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
		dc.drawText(cx-50, cy+70, icons, "S", Graphics.TEXT_JUSTIFY_RIGHT);
		dc.drawText(cx-45, cy+70, Graphics.FONT_TINY, Lang.format("$1$", [info.steps]), Graphics.TEXT_JUSTIFY_LEFT);
		
        // https://github.com/cliffordoravec/all-the-small-things
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}
