import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;

class RectangleHandShape extends HandShape {
    function initialize() {
        HandShape.initialize();
    }

    function draw(dc as Dc, centerX as Number, centerY as Number, angle as Float, length as Float, width as Number) as Void {
        var tipX = centerX + length * Math.cos(angle);
        var tipY = centerY + length * Math.sin(angle);

        var perpAngle = angle + Math.PI / 2.0;
        var offsetX = (width / 2.0) * Math.cos(perpAngle);
        var offsetY = (width / 2.0) * Math.sin(perpAngle);

        dc.fillPolygon([
            [centerX + offsetX, centerY + offsetY],
            [tipX + offsetX, tipY + offsetY],
            [tipX - offsetX, tipY - offsetY],
            [centerX - offsetX, centerY - offsetY]
        ]);

        // Round the tip instead of leaving the flat chisel edge a plain
        // rectangle cuts off square - reads as a finished, capped hand
        // rather than a bar sliced at an arbitrary length.
        dc.fillCircle(tipX, tipY, width / 2.0);
    }
}
