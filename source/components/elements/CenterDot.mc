import Toybox.Graphics;
import Toybox.Lang;

// The small pivot cap real analog watches have where the hands meet -
// subtle, drawn on top of the hands (see Background's element order).
class CenterDot extends WatchFaceElement {
    var handStyle as HandStyle;
    var color as Number;

    function initialize(config as WatchFaceConfig) {
        WatchFaceElement.initialize(config.centerDotDisplay);
        handStyle = config.handStyle;
        color = config.foregroundColor;
    }

    function draw(dc as Dc) as Void {
        var centerX = DialGeometry.centerX(dc);
        var centerY = DialGeometry.centerY(dc);

        // Scale with the hour hand's actual width for the current style
        // (6 matches HourHand's base width) so bolder hand presets get a
        // proportionally bigger cap instead of a fixed size that looks too
        // small next to Rectangle/Dauphine hands or too big next to Light.
        var handWidth = HandRenderer.effectiveWidth(handStyle, 6);
        var radius = handWidth / 2 + 3;

        // A real pivot cap reads as a small bezel, not a flat dot: a dark
        // outer ring around a smaller bright center. A hairline stroke at
        // this scale (a few px radius) just anti-aliases into nothing, so
        // the ring is a second solid fill, sized as a proportion of the
        // cap's own radius rather than a fixed 1px - it stays a visibly
        // thick band whether the cap is small (Light hands) or large
        // (Rectangle/Dauphine).
        var ringThickness = (radius * 0.4).toNumber();
        if (ringThickness < 2) {
            ringThickness = 2;
        }
        var innerRadius = radius - ringThickness;
        if (innerRadius < 1) {
            innerRadius = 1;
        }

        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(centerX, centerY, radius);
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(centerX, centerY, innerRadius);
    }
}
