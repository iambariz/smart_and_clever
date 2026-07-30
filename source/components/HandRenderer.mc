import Toybox.Graphics;
import Toybox.Lang;

// Picks the right HandShape (components/handStyles/) for a style, computes
// its effective width, and delegates the actual drawing to it. HourHand
// and MinuteHand just call drawHand() - they don't know shapes exist.
module HandRenderer {
    // Bolder presets widen the base beyond the plain baseWidth. Exposed so
    // other elements (e.g. the center dot) can scale themselves to match.
    function effectiveWidth(style as HandStyle, baseWidth as Number) as Number {
        if (style == HAND_STYLE_LIGHT) {
            return baseWidth;
        }
        return baseWidth + 4;
    }

    function shapeFor(style as HandStyle) as HandShape {
        if (style == HAND_STYLE_DAUPHINE) {
            return new DauphineHandShape();
        } else if (style == HAND_STYLE_DAUPHINE_FLAT) {
            return new DauphineFlatHandShape();
        } else if (style == HAND_STYLE_RECTANGLE) {
            return new RectangleHandShape();
        }
        return new LightHandShape();
    }

    function drawHand(dc as Dc, centerX as Number, centerY as Number, angle as Float, length as Float, style as HandStyle, baseWidth as Number) as Void {
        var width = effectiveWidth(style, baseWidth);
        var shape = shapeFor(style);
        shape.draw(dc, centerX, centerY, angle, length, width);
    }
}
