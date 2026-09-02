import Toybox.Graphics;
import Toybox.Lang;
import Toybox.ActivityMonitor;

class StepsComplication extends WatchFaceElement {
    var position as Position;

    function initialize(config as WatchFaceConfig) {
        WatchFaceElement.initialize(config.stepsDisplay);
        position = config.stepsPosition;
    }

    function draw(dc as Dc) as Void {
        var steps = ActivityMonitor.getInfo().steps;
        if (steps == null) {
            return;
        }

        var radius = DialGeometry.radius(dc);
        var point = DialGeometry.pointForPosition(dc, position, radius * 0.45);

        var stepsStr = steps.toString();
        var textHeight = dc.getTextDimensions(stepsStr, Graphics.FONT_XTINY)[1];

        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(point[0], point[1] - textHeight / 2, Graphics.FONT_XTINY, stepsStr, Graphics.TEXT_JUSTIFY_CENTER);
    }
}
