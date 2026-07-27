import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Math;

class MinuteHand extends WatchFaceElement {
    var style as HandStyle;

    function initialize(config as WatchFaceConfig) {
        WatchFaceElement.initialize(config.minuteHandDisplay);
        style = config.handStyle;
    }

    function draw(dc as Dc) as Void {
        var centerX = DialGeometry.centerX(dc);
        var centerY = DialGeometry.centerY(dc);
        var radius = DialGeometry.radius(dc);

        var clockTime = System.getClockTime();
        var minutes = clockTime.min;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        var minuteAngle = (minutes * 6 - 90) * Math.PI / 180.0;
        HandRenderer.drawHand(dc, centerX, centerY, minuteAngle, radius * 0.75, style, 4);
    }
}
