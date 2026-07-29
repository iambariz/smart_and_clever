import Toybox.Application;
import Toybox.Application.Properties;
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
        dc.setColor(Properties.getValue("BackgroundColor") as Number, Graphics.COLOR_BLACK);
        dc.clear();

        var elements = buildElements();
        for (var i = 0; i < elements.size(); i++) {
            if (elements[i].isVisible()) {
                elements[i].draw(dc);
            }
        }
    }

    function buildElements() as Array<WatchFaceElement> {
        var config = new WatchFaceConfig(
            numeralStyleFromNumber(Properties.getValue("NumeralStyle") as Number),
            displayStyleFromBoolean(Properties.getValue("ShowHourMarkers") as Boolean),
            displayStyleFromBoolean(Properties.getValue("ShowHourHand") as Boolean),
            displayStyleFromBoolean(Properties.getValue("ShowMinuteHand") as Boolean),
            handStyleFromNumber(Properties.getValue("HandStyle") as Number),
            displayStyleFromBoolean(Properties.getValue("ShowCenterDot") as Boolean),
            displayStyleFromBoolean(Properties.getValue("ShowDateComplication") as Boolean),
            displayStyleFromBoolean(Properties.getValue("ShowDayOfWeek") as Boolean),
            displayStyleFromBoolean(Properties.getValue("ShowDayNumber") as Boolean),
            displayStyleFromBoolean(Properties.getValue("ShowDateBorder") as Boolean),
            displayStyleFromBoolean(Properties.getValue("ShowTemperature") as Boolean),
            positionFromNumber(Properties.getValue("TemperaturePosition") as Number)
        );

        // Draw order is z-order: later elements render on top of earlier
        // ones. Hands go before the center dot (which caps their bases,
        // like a real watch's pivot cover) and after everything else so
        // they're never hidden behind the date box or temperature text.
        return [
            new HourMarkers(config),
            new DateComplication(config),
            new TemperatureComplication(config),
            new HourHand(config),
            new MinuteHand(config),
            new CenterDot(config)
        ] as Array<WatchFaceElement>;
    }
}
