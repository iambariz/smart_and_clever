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
        // A darkened shade of the theme's own main color, not a generic
        // gray - stays in that theme's hue family instead of introducing
        // an unrelated neutral. You only need the hour roughly; full
        // brightness is reserved for the minute hand, which you actually
        // read precisely.
        color = darken(config.foregroundColor);
    }

    // Scales each RGB channel down by the same factor, keeping the hue but
    // dropping the brightness - simple, no color-space conversion needed
    // for a "darker shade of this same color" effect.
    function darken(argbColor as Number) as Number {
        var r = (((argbColor >> 16) & 0xFF) * 0.55).toNumber();
        var g = (((argbColor >> 8) & 0xFF) * 0.55).toNumber();
        var b = ((argbColor & 0xFF) * 0.55).toNumber();
        return (r << 16) | (g << 8) | b;
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
