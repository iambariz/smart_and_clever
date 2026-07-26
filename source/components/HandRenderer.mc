import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;

// Shared helper for drawing a solid, tapered watch hand as a filled
// polygon - used by HourHand and MinuteHand so the shape logic exists once.
module HandRenderer {
    function drawTaperedHand(dc as Dc, centerX as Number, centerY as Number, angle as Float, length as Float, width as Number) as Void {
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
