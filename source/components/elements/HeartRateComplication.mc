import Toybox.Graphics;
import Toybox.Lang;
import Toybox.ActivityMonitor;

class HeartRateComplication extends PositionedComplication {
    function initialize(config as WatchFaceConfig) {
        PositionedComplication.initialize(config.heartRateDisplay, config.heartRatePosition);
    }

    function draw(dc as Dc) as Void {
        var iterator = ActivityMonitor.getHeartRateHistory(1, true);
        var sample = iterator.next();
        if (sample == null || sample.heartRate == ActivityMonitor.INVALID_HR_SAMPLE) {
            return;
        }

        var radius = DialGeometry.radius(dc);
        var point = DialGeometry.pointForPosition(dc, position, radius * 0.45);

        var hrStr = sample.heartRate.toString() + " bpm";
        var textHeight = dc.getTextDimensions(hrStr, Graphics.FONT_XTINY)[1];

        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(point[0], point[1] - textHeight / 2, Graphics.FONT_XTINY, hrStr, Graphics.TEXT_JUSTIFY_CENTER);
    }
}
