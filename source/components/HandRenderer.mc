import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;

// Shared helper for drawing hour/minute hands as filled polygons - used by
// HourHand and MinuteHand so the shape logic exists once.
module HandRenderer {
    function drawHand(dc as Dc, centerX as Number, centerY as Number, angle as Float, length as Float, style as HandStyle, baseWidth as Number) as Void {
        if (style == HAND_STYLE_DAUPHINE) {
            drawFacetedHand(dc, centerX, centerY, angle, length, baseWidth + 4);
        } else {
            drawTaperedHand(dc, centerX, centerY, angle, length, baseWidth);
        }
    }

    // Simple triangle: flat base at the pivot, smoothly tapering to a point.
    function drawTaperedHand(dc as Dc, centerX as Number, centerY as Number, angle as Float, length as Float, width as Number) as Void {
        var tip = pointAt(centerX, centerY, angle, length);

        var perpAngle = angle + Math.PI / 2.0;
        var baseOffset = offsetAt(perpAngle, width / 2.0);

        var points = [
            [centerX + baseOffset[0], centerY + baseOffset[1]],
            [centerX - baseOffset[0], centerY - baseOffset[1]],
            tip
        ];
        dc.fillPolygon(points);
    }

    // Dauphine: flat base at the pivot, straight sides out to a sharp break
    // partway along, then a distinctly narrower taper to the tip - the
    // faceted, diamond-like profile real Dauphine hands have, rather than a
    // single smooth taper.
    function drawFacetedHand(dc as Dc, centerX as Number, centerY as Number, angle as Float, length as Float, baseWidth as Number) as Void {
        var breakFraction = 0.55;
        var breakWidth = baseWidth * 0.35;

        var tip = pointAt(centerX, centerY, angle, length);
        var breakCenter = pointAt(centerX, centerY, angle, length * breakFraction);

        var perpAngle = angle + Math.PI / 2.0;
        var baseOffset = offsetAt(perpAngle, baseWidth / 2.0);
        var breakOffset = offsetAt(perpAngle, breakWidth / 2.0);

        var points = [
            [centerX + baseOffset[0], centerY + baseOffset[1]],
            [breakCenter[0] + breakOffset[0], breakCenter[1] + breakOffset[1]],
            tip,
            [breakCenter[0] - breakOffset[0], breakCenter[1] - breakOffset[1]],
            [centerX - baseOffset[0], centerY - baseOffset[1]]
        ];
        dc.fillPolygon(points);
    }

    function pointAt(centerX as Number, centerY as Number, angle as Float, distance as Float) as Array<Numeric> {
        return [centerX + distance * Math.cos(angle), centerY + distance * Math.sin(angle)];
    }

    function offsetAt(perpAngle as Float, halfWidth as Float) as Array<Numeric> {
        return [halfWidth * Math.cos(perpAngle), halfWidth * Math.sin(perpAngle)];
    }
}
