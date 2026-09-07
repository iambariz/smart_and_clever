import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Weather;
import Toybox.WatchUi;

// Draws one character of a custom bitmap icon font (resources/fonts/) -
// same technique real weather-showing Connect IQ faces use (e.g. Crystal
// Face's weather-icons-20.fnt): each condition maps to a character, drawn
// with a normal dc.drawText() call, just like every other complication's
// plain text. The font is a grayscale PNG the OS tints via dc.setColor,
// so it follows this complication's own color the same way text would.
class WeatherIconComplication extends PositionedComplication {
    var color as Number;
    var iconFont as Graphics.FontReference?;

    function initialize(config as WatchFaceConfig) {
        PositionedComplication.initialize(config.weatherIconDisplay, config.weatherIconPosition);
        color = config.weatherIconColor;
    }

    function draw(dc as Dc) as Void {
        var conditions = Weather.getCurrentConditions();
        if (conditions == null || conditions.condition == null) {
            return;
        }

        if (iconFont == null) {
            iconFont = WatchUi.loadResource(Rez.Fonts.WeatherIconsFont) as Graphics.FontReference;
        }

        var category = categoryFor(conditions.condition as Weather.Condition);
        var glyph = glyphFor(category);

        var radius = DialGeometry.radius(dc);
        var point = DialGeometry.pointForPosition(dc, position, radius * 0.45);
        var textHeight = dc.getTextDimensions(glyph, iconFont)[1];

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(point[0], point[1] - textHeight / 2, iconFont, glyph, Graphics.TEXT_JUSTIFY_CENTER);
    }

    // Weather.Condition has 50+ specific values (light rain, heavy rain,
    // rain/snow mix, etc.) - collapsed here into a handful of buckets.
    // Anything exotic (dust, volcanic ash, tornado, hurricane) falls back
    // to the plain cloud glyph rather than needing its own icon.
    function categoryFor(condition as Weather.Condition) as Symbol {
        if (condition == Weather.CONDITION_CLEAR || condition == Weather.CONDITION_FAIR ||
            condition == Weather.CONDITION_MOSTLY_CLEAR || condition == Weather.CONDITION_PARTLY_CLEAR) {
            return :sun;
        }
        if (condition == Weather.CONDITION_THUNDERSTORMS || condition == Weather.CONDITION_CHANCE_OF_THUNDERSTORMS ||
            condition == Weather.CONDITION_SCATTERED_THUNDERSTORMS) {
            return :storm;
        }
        if (condition == Weather.CONDITION_SNOW || condition == Weather.CONDITION_LIGHT_SNOW ||
            condition == Weather.CONDITION_HEAVY_SNOW || condition == Weather.CONDITION_FLURRIES ||
            condition == Weather.CONDITION_CHANCE_OF_SNOW || condition == Weather.CONDITION_CLOUDY_CHANCE_OF_SNOW ||
            condition == Weather.CONDITION_ICE_SNOW) {
            return :snow;
        }
        if (condition == Weather.CONDITION_RAIN || condition == Weather.CONDITION_LIGHT_RAIN ||
            condition == Weather.CONDITION_HEAVY_RAIN || condition == Weather.CONDITION_DRIZZLE ||
            condition == Weather.CONDITION_SHOWERS || condition == Weather.CONDITION_LIGHT_SHOWERS ||
            condition == Weather.CONDITION_HEAVY_SHOWERS || condition == Weather.CONDITION_SCATTERED_SHOWERS ||
            condition == Weather.CONDITION_CHANCE_OF_SHOWERS || condition == Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN ||
            condition == Weather.CONDITION_SLEET || condition == Weather.CONDITION_FREEZING_RAIN ||
            condition == Weather.CONDITION_HAIL || condition == Weather.CONDITION_RAIN_SNOW ||
            condition == Weather.CONDITION_WINTRY_MIX || condition == Weather.CONDITION_LIGHT_RAIN_SNOW ||
            condition == Weather.CONDITION_HEAVY_RAIN_SNOW || condition == Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW ||
            condition == Weather.CONDITION_CHANCE_OF_RAIN_SNOW) {
            return :rain;
        }
        return :cloud;
    }

    // Matches the char ids in resources/fonts/weather-icons.fnt (A-E).
    function glyphFor(category as Symbol) as String {
        if (category == :sun) {
            return "A";
        } else if (category == :cloud) {
            return "B";
        } else if (category == :rain) {
            return "C";
        } else if (category == :snow) {
            return "D";
        }
        return "E";
    }
}
