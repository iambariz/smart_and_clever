import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Weather;

// Placeholder text label for now, not a drawn icon - matches the plain
// text style every other complication already uses. The category mapping
// is the real work (collapsing Weather.Condition's 50+ specific values
// into a handful of buckets); swapping this for a drawn/bitmap icon later
// only touches draw(), categoryFor() stays the same.
class WeatherIconComplication extends PositionedComplication {
    var color as Number;

    function initialize(config as WatchFaceConfig) {
        PositionedComplication.initialize(config.weatherIconDisplay, config.weatherIconPosition);
        color = config.weatherIconColor;
    }

    function draw(dc as Dc) as Void {
        var conditions = Weather.getCurrentConditions();
        if (conditions == null || conditions.condition == null) {
            return;
        }

        var category = categoryFor(conditions.condition as Weather.Condition);
        var label = labelFor(category);

        var radius = DialGeometry.radius(dc);
        var point = DialGeometry.pointForPosition(dc, position, radius * 0.45);
        var textHeight = dc.getTextDimensions(label, Graphics.FONT_XTINY)[1];

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(point[0], point[1] - textHeight / 2, Graphics.FONT_XTINY, label, Graphics.TEXT_JUSTIFY_CENTER);
    }

    // Weather.Condition has 50+ specific values (light rain, heavy rain,
    // rain/snow mix, etc.) - collapsed here into a handful of buckets.
    // Anything exotic (dust, volcanic ash, tornado, hurricane) falls back
    // to "Cloudy" rather than needing its own label.
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

    function labelFor(category as Symbol) as String {
        if (category == :sun) {
            return "Sunny";
        } else if (category == :rain) {
            return "Rain";
        } else if (category == :snow) {
            return "Snow";
        } else if (category == :storm) {
            return "Storm";
        }
        return "Cloudy";
    }
}
