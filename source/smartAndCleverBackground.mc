import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class Background extends WatchUi.Drawable {
    var elements as Array<WatchFaceElement>;

    function initialize() {
        var dictionary = {
            :identifier => "Background"
        };
        Drawable.initialize(dictionary);

        var config = new WatchFaceConfig(
            numeralStyleFromNumber(getApp().getProperty("NumeralStyle") as Number)
        );

        elements = [
            new HourMarkers(config),
            new ClockHands(),
            new DateComplication(),
            new TemperatureComplication()
        ] as Array<WatchFaceElement>;
    }

    function draw(dc as Dc) as Void {
        dc.setColor(getApp().getProperty("BackgroundColor") as Number, Graphics.COLOR_BLACK);
        dc.clear();

        for (var i = 0; i < elements.size(); i++) {
            elements[i].draw(dc);
        }
    }
}
