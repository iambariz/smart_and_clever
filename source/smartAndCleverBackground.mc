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
        // Set by name, not by constructor position - see WatchFaceConfig's
        // doc comment for why: it makes a silent field swap impossible.
        var config = new WatchFaceConfig();
        config.numeralStyle = numeralStyleFromNumber(Properties.getValue("NumeralStyle") as Number);
        config.foregroundColor = Properties.getValue("ForegroundColor") as Number;
        config.hourMarkersDisplay = displayStyleFromBoolean(Properties.getValue("ShowHourMarkers") as Boolean);
        config.hourHandDisplay = displayStyleFromBoolean(Properties.getValue("ShowHourHand") as Boolean);
        config.minuteHandDisplay = displayStyleFromBoolean(Properties.getValue("ShowMinuteHand") as Boolean);
        config.secondHandDisplay = displayStyleFromBoolean(Properties.getValue("ShowSecondHand") as Boolean);
        config.handStyle = handStyleFromNumber(Properties.getValue("HandStyle") as Number);
        config.centerDotDisplay = displayStyleFromBoolean(Properties.getValue("ShowCenterDot") as Boolean);
        config.dateDisplay = displayStyleFromBoolean(Properties.getValue("ShowDateComplication") as Boolean);
        config.dayOfWeekDisplay = displayStyleFromBoolean(Properties.getValue("ShowDayOfWeek") as Boolean);
        config.dayNumberDisplay = displayStyleFromBoolean(Properties.getValue("ShowDayNumber") as Boolean);
        config.dateBorderDisplay = displayStyleFromBoolean(Properties.getValue("ShowDateBorder") as Boolean);
        config.temperatureDisplay = displayStyleFromBoolean(Properties.getValue("ShowTemperature") as Boolean);
        config.temperaturePosition = positionFromNumber(Properties.getValue("TemperaturePosition") as Number);
        config.batteryDisplay = displayStyleFromBoolean(Properties.getValue("ShowBattery") as Boolean);
        config.batteryPosition = positionFromNumber(Properties.getValue("BatteryPosition") as Number);
        config.stepsDisplay = displayStyleFromBoolean(Properties.getValue("ShowSteps") as Boolean);
        config.stepsPosition = positionFromNumber(Properties.getValue("StepsPosition") as Number);
        config.heartRateDisplay = displayStyleFromBoolean(Properties.getValue("ShowHeartRate") as Boolean);
        config.heartRatePosition = positionFromNumber(Properties.getValue("HeartRatePosition") as Number);

        var positionedComplications = [
            new TemperatureComplication(config),
            new BatteryComplication(config),
            new StepsComplication(config),
            new HeartRateComplication(config)
        ] as Array<PositionedComplication>;
        resolvePositionConflicts(positionedComplications);

        // Draw order is z-order: later elements render on top of earlier
        // ones. Hands go before the center dot (which caps their bases,
        // like a real watch's pivot cover) and after everything else so
        // they're never hidden behind the date box or temperature text.
        return [
            new HourMarkers(config),
            new DateComplication(config),
            positionedComplications[0],
            positionedComplications[1],
            positionedComplications[2],
            positionedComplications[3],
            new HourHand(config),
            new MinuteHand(config),
            new SecondHand(config),
            new CenterDot(config)
        ] as Array<WatchFaceElement>;
    }

    function resolvePositionConflicts(complications as Array<PositionedComplication>) as Void {
        var claimedPositions = [] as Array<Position>;
        for (var i = 0; i < complications.size(); i++) {
            var complication = complications[i];
            if (!complication.isVisible()) {
                continue;
            }
            if (claimedPositions.indexOf(complication.position) >= 0) {
                complication.suppress();
            } else {
                claimedPositions.add(complication.position);
            }
        }
    }
}
