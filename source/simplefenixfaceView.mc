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

    // Update the view
    function onUpdate(dc) {
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
        var battery = Math.floor(System.getSystemStats().battery).toNumber();
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
