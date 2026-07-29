import Toybox.Graphics;
import Toybox.Lang;

// The small pivot cap real analog watches have where the hands meet -
// subtle, drawn on top of the hands (see Background's element order).
class CenterDot extends WatchFaceElement {
    var handStyle as HandStyle;

    function initialize(config as WatchFaceConfig) {
        WatchFaceElement.initialize(config.centerDotDisplay);
        handStyle = config.handStyle;
    }

    function draw(dc as Dc) as Void {
        var centerX = DialGeometry.centerX(dc);
        var centerY = DialGeometry.centerY(dc);

        // Scale with the hour hand's actual width for the current style
        // (6 matches HourHand's base width) so bolder hand presets get a
        // proportionally bigger cap instead of a fixed size that looks too
        // small next to Rectangle/Dauphine hands or too big next to Light.
        var handWidth = HandRenderer.effectiveWidth(handStyle, 6);
        var radius = handWidth / 2 + 1;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(centerX, centerY, radius);
    }
}
