import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Math;

class MinuteHand extends WatchFaceElement {
    var style as HandStyle;
    var color as Number;

    function initialize(config as WatchFaceConfig) {
        WatchFaceElement.initialize(config.minuteHandDisplay);
        style = config.handStyle;
        color = config.foregroundColor;
    }

    function draw(dc as Dc) as Void {
        var centerX = DialGeometry.centerX(dc);
        var centerY = DialGeometry.centerY(dc);
        var radius = DialGeometry.radius(dc);

        var clockTime = System.getClockTime();
        var minutes = clockTime.min;

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);

        var minuteAngle = DialGeometry.clockAngle(minutes * 6);
        HandRenderer.drawHand(dc, centerX, centerY, minuteAngle, radius * 0.75, style, 4);
    }
}
