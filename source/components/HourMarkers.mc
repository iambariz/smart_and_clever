import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;

// Hour markers, styled per WatchFaceConfig.numeralStyle: Roman numerals at
// every hour, Arabic numbers at every hour, or plain batons (None).
class HourMarkers extends WatchFaceElement {
    var style as NumeralStyle;

    const ROMAN_NUMERALS = [
        "XII", "I", "II", "III", "IV", "V",
        "VI", "VII", "VIII", "IX", "X", "XI"
    ];

    const ARABIC_NUMERALS = [
        "12", "1", "2", "3", "4", "5",
        "6", "7", "8", "9", "10", "11"
    ];

    function initialize(config as WatchFaceConfig) {
        WatchFaceElement.initialize();
        style = config.numeralStyle;
    }

    function draw(dc as Dc) as Void {
        var centerX = DialGeometry.centerX(dc);
        var centerY = DialGeometry.centerY(dc);
        var radius = DialGeometry.radius(dc);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        for (var i = 0; i < 12; i++) {
            var angle = (i * 30 - 90) * Math.PI / 180.0;

            if (style == NUMERAL_STYLE_NONE) {
                drawBaton(dc, centerX, centerY, radius, angle);
            } else if (style == NUMERAL_STYLE_ARABIC) {
                drawNumeral(dc, centerX, centerY, radius, angle, ARABIC_NUMERALS[i]);
            } else {
                drawNumeral(dc, centerX, centerY, radius, angle, ROMAN_NUMERALS[i]);
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
        dc.drawText(textX, textY - 10, Graphics.FONT_XTINY, text, Graphics.TEXT_JUSTIFY_CENTER);
    }
}
