import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

// Small filled-circle MenuItem icon so a color scheme's accent is visible
// in the on-device list before it's selected - the palette-review artifact's
// "colored dot next to the name" language, carried into the real menu.
// The thin gray ring keeps it visible even for a fill close to the menu's
// own background (e.g. a near-black scheme).
class ColorDotIcon extends WatchUi.Drawable {
    var color as Number;

    function initialize(color as Number) {
        Drawable.initialize({});
        self.color = color;
    }

    function draw(dc as Dc) as Void {
        var w = dc.getWidth();
        var h = dc.getHeight();
        var cx = w / 2;
        var cy = h / 2;
        var r = (w < h ? w : h) / 2 - 3;

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(cx, cy, r);
        dc.setPenWidth(1);
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(cx, cy, r);
    }
}
