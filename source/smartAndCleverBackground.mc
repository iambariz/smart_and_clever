import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

// Composes the dial out of independent elements (see WatchFaceElement) -
// each one owns its own drawing logic; this class just clears the screen
// and calls draw() on each visible one, in order.
class Background extends WatchUi.Drawable {
    function initialize() {
        var dictionary = {
            :identifier => "Background"
        };
        Drawable.initialize(dictionary);
    }

    function draw(dc as Dc) as Void {
        dc.setColor(getApp().getProperty("BackgroundColor") as Number, Graphics.COLOR_BLACK);
        dc.clear();

        var elements = buildElements();
        for (var i = 0; i < elements.size(); i++) {
            if (elements[i].isVisible()) {
                elements[i].draw(dc);
            }
        }
    }

    function buildElements() as Array<WatchFaceElement> {
        var app = getApp();
        var config = new WatchFaceConfig(
            numeralStyleFromNumber(app.getProperty("NumeralStyle") as Number),
            displayStyleFromBoolean(app.getProperty("ShowHourMarkers") as Boolean),
            displayStyleFromBoolean(app.getProperty("ShowHourHand") as Boolean),
            displayStyleFromBoolean(app.getProperty("ShowMinuteHand") as Boolean),
            handStyleFromNumber(app.getProperty("HandStyle") as Number),
            displayStyleFromBoolean(app.getProperty("ShowDateComplication") as Boolean),
            displayStyleFromBoolean(app.getProperty("ShowDayOfWeek") as Boolean),
            displayStyleFromBoolean(app.getProperty("ShowDayNumber") as Boolean),
            displayStyleFromBoolean(app.getProperty("ShowDateBorder") as Boolean),
            displayStyleFromBoolean(app.getProperty("ShowTemperature") as Boolean),
            positionFromNumber(app.getProperty("TemperaturePosition") as Number)
        );

        // Draw order is z-order: later elements render on top of earlier
        // ones. Hands go last so they're always on top, never hidden behind
        // the date box or temperature text as they sweep past.
        return [
            new HourMarkers(config),
            new DateComplication(config),
            new TemperatureComplication(config),
            new HourHand(config),
            new MinuteHand(config)
        ] as Array<WatchFaceElement>;
    }
}
