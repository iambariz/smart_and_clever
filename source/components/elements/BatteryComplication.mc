import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;

class BatteryComplication extends PositionedComplication {
    function initialize(config as WatchFaceConfig) {
        PositionedComplication.initialize(config.batteryDisplay, config.batteryPosition);
    }

    function draw(dc as Dc) as Void {
        var battery = System.getSystemStats().battery;

        var radius = DialGeometry.radius(dc);
        var point = DialGeometry.pointForPosition(dc, position, radius * 0.45);

        var batteryStr = battery.format("%.0f") + "%";
        var textHeight = dc.getTextDimensions(batteryStr, Graphics.FONT_XTINY)[1];

        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(point[0], point[1] - textHeight / 2, Graphics.FONT_XTINY, batteryStr, Graphics.TEXT_JUSTIFY_CENTER);
    }
}
