import Toybox.Lang;

// Plain data holder (DTO) for user-configurable display options. It has no
// behavior of its own - something builds one from the app's Properties,
// elements just read values back out of it.
class WatchFaceConfig {
    var numeralStyle as NumeralStyle;
    var hourMarkersDisplay as DisplayStyle;
    var hourHandDisplay as DisplayStyle;
    var minuteHandDisplay as DisplayStyle;
    var dateDisplay as DisplayStyle;
    var dayOfWeekDisplay as DisplayStyle;
    var dayNumberDisplay as DisplayStyle;
    var dateBorderDisplay as DisplayStyle;
    var temperatureDisplay as DisplayStyle;
    var temperaturePosition as Position;

    function initialize(
        numeralStyle as NumeralStyle,
        hourMarkersDisplay as DisplayStyle,
        hourHandDisplay as DisplayStyle,
        minuteHandDisplay as DisplayStyle,
        dateDisplay as DisplayStyle,
        dayOfWeekDisplay as DisplayStyle,
        dayNumberDisplay as DisplayStyle,
        dateBorderDisplay as DisplayStyle,
        temperatureDisplay as DisplayStyle,
        temperaturePosition as Position
    ) {
        self.numeralStyle = numeralStyle;
        self.hourMarkersDisplay = hourMarkersDisplay;
        self.hourHandDisplay = hourHandDisplay;
        self.minuteHandDisplay = minuteHandDisplay;
        self.dateDisplay = dateDisplay;
        self.dayOfWeekDisplay = dayOfWeekDisplay;
        self.dayNumberDisplay = dayNumberDisplay;
        self.dateBorderDisplay = dateBorderDisplay;
        self.temperatureDisplay = temperatureDisplay;
        self.temperaturePosition = temperaturePosition;
    }
}
