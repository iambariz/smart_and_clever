import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;

class HourMarkers extends WatchFaceElement {
    function initialize() {
        WatchFaceElement.initialize();
    }

    function draw(dc as Dc) as Void {
        var centerX = DialGeometry.centerX(dc);
        var centerY = DialGeometry.centerY(dc);
        var radius = DialGeometry.radius(dc);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        for (var i = 0; i < 12; i++) {
            var angle = (i * 30 - 90) * Math.PI / 180.0;

            if (i == 0) {
                drawNumeral(dc, centerX, centerY, radius, angle, "XII");
            } else if (i == 6) {
                drawNumeral(dc, centerX, centerY, radius, angle, "VI");
            } else {
                drawBaton(dc, centerX, centerY, radius, angle);
            }
        }
    }

    function drawBaton(dc as Dc, centerX as Number, centerY as Number, radius as Number, angle as Float) as Void {
        dc.setPenWidth(2);
        var startX = centerX + (radius - 10) * Math.cos(angle);
        var startY = centerY + (radius - 10) * Math.sin(angle);
        var endX = centerX + radius * Math.cos(angle);
        var endY = centerY + radius * Math.sin(angle);
        dc.drawLine(startX, startY, endX, endY);
    }

    function drawNumeral(dc as Dc, centerX as Number, centerY as Number, radius as Number, angle as Float, text as String) as Void {
        var textX = centerX + (radius - 20) * Math.cos(angle);
        var textY = centerY + (radius - 20) * Math.sin(angle);
        dc.drawText(textX, textY - 10, Graphics.FONT_SMALL, text, Graphics.TEXT_JUSTIFY_CENTER);
    }
}
