import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Math;

// Always drawn as a thin needle regardless of the chosen HandStyle - real
// watches keep the second hand light even when hour/minute hands are bold,
// so it doesn't compete visually with them.
class SecondHand extends WatchFaceElement {
    var color as Number;

    function initialize(config as WatchFaceConfig) {
        WatchFaceElement.initialize(config.secondHandDisplay);
        color = config.foregroundColor;
    }

    function draw(dc as Dc) as Void {
        var centerX = DialGeometry.centerX(dc);
        var centerY = DialGeometry.centerY(dc);
        var radius = DialGeometry.radius(dc);

        var clockTime = System.getClockTime();
        var seconds = clockTime.sec;

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);

        var secondAngle = DialGeometry.clockAngle(seconds * 6);
        HandRenderer.drawHand(dc, centerX, centerY, secondAngle, radius * 0.85, HAND_STYLE_LIGHT, 2);
    }
}
