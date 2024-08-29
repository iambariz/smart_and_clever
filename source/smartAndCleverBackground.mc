import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

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


        // Draw the ticks
        for (var i = 0; i < 60; i++) {
            dc.setPenWidth(3);
            var angle = (i * 6) * (Math.PI / 180);
            var tickStartX = centerX + (radius - 10) * Math.cos(angle);
            var tickStartY = centerY + (radius - 10) * Math.sin(angle);
            var tickEndX = centerX + radius * Math.cos(angle);
            var tickEndY = centerY + radius * Math.sin(angle);

        if (i % 5 == 0) {  // Every 5th tick mark
            dc.setPenWidth(5);
        }
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
}