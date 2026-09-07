import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Weather;

class TemperatureComplication extends PositionedComplication {
    var color as Number;

    function initialize(config as WatchFaceConfig) {
        PositionedComplication.initialize(config.temperatureDisplay, config.temperaturePosition);
        color = config.temperatureColor;
    }

    function draw(dc as Dc) as Void {
        var conditions = Weather.getCurrentConditions();
        if (conditions == null || conditions.temperature == null) {
            return;
        }

        var radius = DialGeometry.radius(dc);
        var point = DialGeometry.pointForPosition(dc, position, radius * 0.45);

        var tempStr = conditions.temperature.format("%.0f") + "°C";
        var textHeight = dc.getTextDimensions(tempStr, Graphics.FONT_XTINY)[1];

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(point[0], point[1] - textHeight / 2, Graphics.FONT_XTINY, tempStr, Graphics.TEXT_JUSTIFY_CENTER);
    }
}
