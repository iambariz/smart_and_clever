import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Time;
import Toybox.Time.Gregorian;

// Day/date window at the 3 o'clock mark, like a classic day-date dial.
// Day-of-week, day-number, and the border are each independently toggleable;
// the box always sizes itself to whichever combination ends up shown.
class DateComplication extends WatchFaceElement {
    var showDayOfWeek as Boolean;
    var showDayNumber as Boolean;
    var showBorder as Boolean;
    var color as Number;

    function initialize(config as WatchFaceConfig) {
        WatchFaceElement.initialize(config.dateDisplay);
        showDayOfWeek = config.dayOfWeekDisplay == DISPLAY_SHOWN;
        showDayNumber = config.dayNumberDisplay == DISPLAY_SHOWN;
        showBorder = config.dateBorderDisplay == DISPLAY_SHOWN;
        // Dimmed toward the background rather than a fixed gray, so it
        // reads as a subtle secondary element against any theme (dark or
        // light) instead of only the default black-on-white one.
        color = mixColor(config.foregroundColor, config.backgroundColor, 0.25);
    }

    function draw(dc as Dc) as Void {
        var dateString = buildDateString();
        if (dateString.equals("")) {
            return;
        }

        var centerX = DialGeometry.centerX(dc);
        var centerY = DialGeometry.centerY(dc);
        var radius = DialGeometry.radius(dc);

        var font = Graphics.FONT_XTINY;
        var textDimensions = dc.getTextDimensions(dateString, font);
        var textWidth = textDimensions[0];
        var textHeight = textDimensions[1];

        var paddingX = 8;
        var paddingY = 4;
        var boxWidth = textWidth + paddingX * 2;
        var boxHeight = textHeight + paddingY * 2;

        var boxCenterX = centerX + radius * 0.5;
        var boxCenterY = centerY;

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        if (showBorder) {
            dc.drawRoundedRectangle(boxCenterX - boxWidth / 2, boxCenterY - boxHeight / 2, boxWidth, boxHeight, 6);
        }
        dc.drawText(boxCenterX, boxCenterY - textHeight / 2, font, dateString, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function buildDateString() as String {
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        return formatDateComplicationString(today.day_of_week, today.day, showDayOfWeek, showDayNumber);
    }
}
