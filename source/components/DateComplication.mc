import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Time;
import Toybox.Time.Gregorian;

// Day/date window at the 3 o'clock mark, like a classic day-date dial.
class DateComplication extends WatchFaceElement {
    function initialize() {
        WatchFaceElement.initialize();
    }

    function draw(dc as Dc) as Void {
        var centerX = DialGeometry.centerX(dc);
        var centerY = DialGeometry.centerY(dc);
        var radius = DialGeometry.radius(dc);

        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dateString = Lang.format("$1$ $2$", [today.day_of_week, today.day]);

        var font = Graphics.FONT_XTINY;
        var textDimensions = dc.getTextDimensions(dateString, font);
        var textWidth = textDimensions[0];
        var textHeight = textDimensions[1];

        var paddingX = 8;
        var paddingY = 4;
        var boxWidth = textWidth + paddingX * 2;
        var boxHeight = textHeight + paddingY * 2;

        var boxCenterX = centerX + radius * 0.55;
        var boxCenterY = centerY;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawRectangle(boxCenterX - boxWidth / 2, boxCenterY - boxHeight / 2, boxWidth, boxHeight);
        dc.drawText(boxCenterX, boxCenterY - textHeight / 2, font, dateString, Graphics.TEXT_JUSTIFY_CENTER);
    }
}
