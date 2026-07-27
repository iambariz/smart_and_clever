import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;

// Shared helper for drawing hour/minute hands as filled polygons - used by
// HourHand and MinuteHand so the shape logic exists once.
module HandRenderer {
    function drawHand(dc as Dc, centerX as Number, centerY as Number, angle as Float, length as Float, style as HandStyle, baseWidth as Number) as Void {
        if (style == HAND_STYLE_DAUPHINE) {
            drawFacetedHand(dc, centerX, centerY, angle, length, baseWidth + 4, 0);
        } else if (style == HAND_STYLE_DAUPHINE_FLAT) {
            var width = baseWidth + 4;
            var tipWidth = (width * 0.35 * 0.4).toNumber();
            drawFacetedHand(dc, centerX, centerY, angle, length, width, tipWidth);
        } else {
            drawTaperedHand(dc, centerX, centerY, angle, length, baseWidth);
        }
    }

    // Simple triangle: flat base at the pivot, smoothly tapering to a point.
    function drawTaperedHand(dc as Dc, centerX as Number, centerY as Number, angle as Float, length as Float, width as Number) as Void {
        var tipX = centerX + length * Math.cos(angle);
        var tipY = centerY + length * Math.sin(angle);

        var perpAngle = angle + Math.PI / 2.0;
        var offsetX = (width / 2.0) * Math.cos(perpAngle);
        var offsetY = (width / 2.0) * Math.sin(perpAngle);

        dc.fillPolygon([
            [centerX + offsetX, centerY + offsetY],
            [centerX - offsetX, centerY - offsetY],
            [tipX, tipY]
        ]);
    }

    // Dauphine: flat base at the pivot, straight sides out to a sharp break
    // partway along, then a distinctly narrower taper to the tip - the
    // faceted, diamond-like profile real Dauphine hands have, rather than a
    // single smooth taper. tipWidth of 0 ends in a sharp point; a positive
    // tipWidth ends in a flat/chisel head instead (the "flat" variant).
    function drawFacetedHand(dc as Dc, centerX as Number, centerY as Number, angle as Float, length as Float, baseWidth as Number, tipWidth as Number) as Void {
        var breakFraction = 0.55;
        var breakWidth = baseWidth * 0.35;
        var breakLength = length * breakFraction;

        var breakCenterX = centerX + breakLength * Math.cos(angle);
        var breakCenterY = centerY + breakLength * Math.sin(angle);

        var perpAngle = angle + Math.PI / 2.0;
        var baseOffsetX = (baseWidth / 2.0) * Math.cos(perpAngle);
        var baseOffsetY = (baseWidth / 2.0) * Math.sin(perpAngle);
        var breakOffsetX = (breakWidth / 2.0) * Math.cos(perpAngle);
        var breakOffsetY = (breakWidth / 2.0) * Math.sin(perpAngle);

        if (tipWidth <= 0) {
            var tipX = centerX + length * Math.cos(angle);
            var tipY = centerY + length * Math.sin(angle);

            dc.fillPolygon([
                [centerX + baseOffsetX, centerY + baseOffsetY],
                [breakCenterX + breakOffsetX, breakCenterY + breakOffsetY],
                [tipX, tipY],
                [breakCenterX - breakOffsetX, breakCenterY - breakOffsetY],
                [centerX - baseOffsetX, centerY - baseOffsetY]
            ]);
        } else {
            var tipCenterX = centerX + length * Math.cos(angle);
            var tipCenterY = centerY + length * Math.sin(angle);
            var tipOffsetX = (tipWidth / 2.0) * Math.cos(perpAngle);
            var tipOffsetY = (tipWidth / 2.0) * Math.sin(perpAngle);

            dc.fillPolygon([
                [centerX + baseOffsetX, centerY + baseOffsetY],
                [breakCenterX + breakOffsetX, breakCenterY + breakOffsetY],
                [tipCenterX + tipOffsetX, tipCenterY + tipOffsetY],
                [tipCenterX - tipOffsetX, tipCenterY - tipOffsetY],
                [breakCenterX - breakOffsetX, breakCenterY - breakOffsetY],
                [centerX - baseOffsetX, centerY - baseOffsetY]
            ]);
        }
    }
}
