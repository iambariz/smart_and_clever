import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Math;

class HourHand extends WatchFaceElement {
    var style as HandStyle;
    var color as Number;

    function initialize(config as WatchFaceConfig) {
        WatchFaceElement.initialize(config.hourHandDisplay);
        style = config.handStyle;
        color = config.foregroundColor;
    }

    function draw(dc as Dc) as Void {
        var centerX = DialGeometry.centerX(dc);
        var centerY = DialGeometry.centerY(dc);
        var radius = DialGeometry.radius(dc);

        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        var minutes = clockTime.min;

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);

        var hourAngle = DialGeometry.clockAngle((hours % 12) * 30 + minutes * 0.5);
        HandRenderer.drawHand(dc, centerX, centerY, hourAngle, radius * 0.5, style, 6);
    }
}
