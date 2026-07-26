import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Weather;
import Toybox.Time;
import Toybox.Time.Gregorian;

class Background extends WatchUi.Drawable {
    function initialize() {
        var dictionary = {
            :identifier => "Background"
        };
        Drawable.initialize(dictionary);
    }

    function draw(dc as Dc) as Void {
        // Set the overall background color of the watch face
        dc.setColor(getApp().getProperty("BackgroundColor") as Number, Graphics.COLOR_BLACK);
        dc.clear();  // Clears the screen with the background color

        // Draw a blue rectangle (commented out)
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);  // Foreground color for the rectangle
        // dc.fillRectangle(100, 100, 100, 100);  // Position and size of the rectangle

        // Get the current time
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        var minutes = clockTime.min;

        //Output time
        System.println("Time: " + hours + ":" + minutes);


        // Get the screen dimensions
        var screenWidth = dc.getWidth();
        var screenHeight = dc.getHeight();

        // Set the center of the clock
        var centerX = screenWidth / 2;
        var centerY = screenHeight / 2;
        var radius = calculateRadius(screenWidth, screenHeight);
            dc.setPenWidth(3);
        // var temperature = getApp().getProperty("CurrentTemperature");
        var temp = Weather.getCurrentConditions().temperature;


        // var temp1  = Lang.format("$1$", [temp]);


        System.println(1);
        // var tempStr = Lang.format("$1$°C", [temp]);
        // System.println(tempStr.format("%.2f"));

        // Draw weather information
        drawWeather(dc, centerX, centerY, temp);

        drawDate(dc, screenWidth * 0.75 , centerY, temp);


        // Draw the ticks - minimal marker per hour
        dc.setPenWidth(2);
        for (var i = 0; i < 12; i++) {
            var angle = (i * 30) * (Math.PI / 180);
            var tickStartX = centerX + (radius - 8) * Math.cos(angle);
            var tickStartY = centerY + (radius - 8) * Math.sin(angle);
            var tickEndX = centerX + radius * Math.cos(angle);
            var tickEndY = centerY + radius * Math.sin(angle);

            dc.drawLine(tickStartX, tickStartY, tickEndX, tickEndY);
        }

    
        // Draw the hour hand
    var hourAngle = ((hours % 12) * 30 + minutes * 0.5 - 90) * (Math.PI / 180); // Adjust angle
        var hourHandX = centerX + (radius - 40) * Math.cos(hourAngle);
        var hourHandY = centerY + (radius - 40) * Math.sin(hourAngle);
        System.println(centerX + "" + centerY + "" + hourHandX + "" +""+ hourHandY);
        dc.drawLine(centerX, centerY, hourHandX, hourHandY);
    
        // Draw the minute hand
    var minuteAngle = (minutes * 6 - 90) * (Math.PI / 180); // Adjust angle
        var minuteHandX = centerX + (radius - 20) * Math.cos(minuteAngle);
        var minuteHandY = centerY + (radius - 20) * Math.sin(minuteAngle);
        dc.drawLine(centerX, centerY, minuteHandX, minuteHandY);
    }

    function calculateRadius(screenWidth, screenHeight) {
        var radius = (screenWidth < screenHeight ? screenWidth : screenHeight) / 2 - 20;
        return radius;
    }
function drawWeather(dc as Dc, centerX, centerY, temperature) {
    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);

    // Assuming the temperature data is a string like "21°C"
    // var tempStr = Lang.format("%.1f°C", temperature);
    // System.println(tempStr);

        var tempStr = temperature.format("%.1f") + "°C";


        // System.println(tempStr.toFloat());

    // Draw the text centered horizontally and adjust vertically
    dc.drawText(centerX, centerY + 75, Graphics.FONT_XTINY, tempStr, Graphics.TEXT_JUSTIFY_CENTER);
}

    function drawDate(dc as Dc, centerX, centerY, temperature) {
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dateString = Lang.format(
        "$1$ $2$",
        [
            today.day_of_week,
            today.day,
        ]
        );

        dc.drawText(centerX, centerY -20, Graphics.FONT_XTINY, dateString, Graphics.TEXT_JUSTIFY_CENTER);
    }



}