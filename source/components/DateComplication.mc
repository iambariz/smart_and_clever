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

        var boxCenterX = centerX + radius * 0.55;
        var boxCenterY = centerY;
        var boxWidth = 46;
        var boxHeight = 20;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawRectangle(boxCenterX - boxWidth / 2, boxCenterY - boxHeight / 2, boxWidth, boxHeight);
        dc.drawText(boxCenterX, boxCenterY - 7, Graphics.FONT_XTINY, dateString, Graphics.TEXT_JUSTIFY_CENTER);
    }
}
