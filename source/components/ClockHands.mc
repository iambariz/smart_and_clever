import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Math;

class ClockHands extends WatchFaceElement {
    function initialize() {
        WatchFaceElement.initialize();
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
        drawHand(dc, centerX, centerY, hourAngle, radius * 0.5, 6);

        var minuteAngle = (minutes * 6 - 90) * Math.PI / 180.0;
        drawHand(dc, centerX, centerY, minuteAngle, radius * 0.75, 4);
    }

    function drawHand(dc as Dc, centerX as Number, centerY as Number, angle as Float, length as Float, width as Number) as Void {
        var tipX = centerX + length * Math.cos(angle);
        var tipY = centerY + length * Math.sin(angle);

        var perpAngle = angle + Math.PI / 2.0;
        var halfWidth = width / 2.0;
        var offsetX = halfWidth * Math.cos(perpAngle);
        var offsetY = halfWidth * Math.sin(perpAngle);

        var points = [
            [centerX + offsetX, centerY + offsetY],
            [centerX - offsetX, centerY - offsetY],
            [tipX, tipY]
        ];
        dc.fillPolygon(points);
    }
}
