import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;

// Shared faceted-taper geometry for Dauphine and Dauphine (Flat):
class FacetedHandShape extends HandShape {
    function initialize() {
        HandShape.initialize();
    }

    function draw(dc as Dc, centerX as Number, centerY as Number, angle as Float, length as Float, width as Number) as Void {
        var breakFraction = 0.55;
        var breakWidth = width * 0.35;
        var breakLength = length * breakFraction;
        var tipWidth = tipWidthFor(width);

        var breakCenterX = centerX + breakLength * Math.cos(angle);
        var breakCenterY = centerY + breakLength * Math.sin(angle);

        var perpAngle = angle + Math.PI / 2.0;
        var baseOffsetX = (width / 2.0) * Math.cos(perpAngle);
        var baseOffsetY = (width / 2.0) * Math.sin(perpAngle);
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

    // Subclasses override: 0 = sharp point, positive = blunt/chisel head.
    function tipWidthFor(width as Number) as Number {
        return 0;
    }
}
