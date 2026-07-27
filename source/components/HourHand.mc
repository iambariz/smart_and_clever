import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Math;

class HourHand extends WatchFaceElement {
    var style as HandStyle;

    function initialize(config as WatchFaceConfig) {
        WatchFaceElement.initialize(config.hourHandDisplay);
        style = config.handStyle;
    }

    function draw(dc as Dc) as Void {
        var centerX = DialGeometry.centerX(dc);
        var centerY = DialGeometry.centerY(dc);
        var radius = DialGeometry.radius(dc);

        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        var minutes = clockTime.min;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        var hourAngle = ((hours % 12) * 30 + minutes * 0.5 - 90) * Math.PI / 180.0;
        HandRenderer.drawHand(dc, centerX, centerY, hourAngle, radius * 0.5, style, 6);
    }
}
