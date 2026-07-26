import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Math;

class MinuteHand extends WatchFaceElement {
    function initialize(config as WatchFaceConfig) {
        WatchFaceElement.initialize(config.minuteHandDisplay);
    }

    function draw(dc as Dc) as Void {
        var centerX = DialGeometry.centerX(dc);
        var centerY = DialGeometry.centerY(dc);
        var radius = DialGeometry.radius(dc);

        var clockTime = System.getClockTime();
        var minutes = clockTime.min;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        var minuteAngle = (minutes * 6 - 90) * Math.PI / 180.0;
        HandRenderer.drawTaperedHand(dc, centerX, centerY, minuteAngle, radius * 0.75, 4);
    }
}
