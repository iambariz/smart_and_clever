import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Weather;

class TemperatureComplication extends WatchFaceElement {
    function initialize(config as WatchFaceConfig) {
        WatchFaceElement.initialize(config.temperatureDisplay);
    }

    function draw(dc as Dc) as Void {
        var centerX = DialGeometry.centerX(dc);
        var centerY = DialGeometry.centerY(dc);

        var temp = Weather.getCurrentConditions().temperature;
        var tempStr = temp.format("%.1f") + "°C";

        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, centerY + 75, Graphics.FONT_XTINY, tempStr, Graphics.TEXT_JUSTIFY_CENTER);
    }
}
