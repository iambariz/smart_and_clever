import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Weather;

class TemperatureComplication extends WatchFaceElement {
    var position as Position;

    function initialize(config as WatchFaceConfig) {
        WatchFaceElement.initialize(config.temperatureDisplay);
        position = config.temperaturePosition;
    }

    function draw(dc as Dc) as Void {
        var radius = DialGeometry.radius(dc);
        var point = DialGeometry.pointForPosition(dc, position, radius * 0.45);

        var temp = Weather.getCurrentConditions().temperature;
        var tempStr = temp.format("%.1f") + "°C";

        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(point[0], point[1], Graphics.FONT_XTINY, tempStr, Graphics.TEXT_JUSTIFY_CENTER);
    }
}
