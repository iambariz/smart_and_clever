import Toybox.Lang;

// Plain data holder (DTO) for user-configurable display options. It has no
// behavior of its own - something builds one from the app's Properties,
// elements just read values back out of it.
class WatchFaceConfig {
    var numeralStyle as NumeralStyle;
    var foregroundColor as Number;
    var hourMarkersDisplay as DisplayStyle;
    var hourHandDisplay as DisplayStyle;
    var minuteHandDisplay as DisplayStyle;
    var secondHandDisplay as DisplayStyle;
    var handStyle as HandStyle;
    var centerDotDisplay as DisplayStyle;
    var dateDisplay as DisplayStyle;
    var dayOfWeekDisplay as DisplayStyle;
    var dayNumberDisplay as DisplayStyle;
    var dateBorderDisplay as DisplayStyle;
    var temperatureDisplay as DisplayStyle;
    var temperaturePosition as Position;
    var batteryDisplay as DisplayStyle;
    var batteryPosition as Position;

    function initialize(
        numeralStyle as NumeralStyle,
        foregroundColor as Number,
        hourMarkersDisplay as DisplayStyle,
        hourHandDisplay as DisplayStyle,
        minuteHandDisplay as DisplayStyle,
        secondHandDisplay as DisplayStyle,
        handStyle as HandStyle,
        centerDotDisplay as DisplayStyle,
        dateDisplay as DisplayStyle,
        dayOfWeekDisplay as DisplayStyle,
        dayNumberDisplay as DisplayStyle,
        dateBorderDisplay as DisplayStyle,
        temperatureDisplay as DisplayStyle,
        temperaturePosition as Position,
        batteryDisplay as DisplayStyle,
        batteryPosition as Position
    ) {
        self.numeralStyle = numeralStyle;
        self.foregroundColor = foregroundColor;
        self.hourMarkersDisplay = hourMarkersDisplay;
        self.hourHandDisplay = hourHandDisplay;
        self.minuteHandDisplay = minuteHandDisplay;
        self.secondHandDisplay = secondHandDisplay;
        self.handStyle = handStyle;
        self.centerDotDisplay = centerDotDisplay;
        self.dateDisplay = dateDisplay;
        self.dayOfWeekDisplay = dayOfWeekDisplay;
        self.dayNumberDisplay = dayNumberDisplay;
        self.dateBorderDisplay = dateBorderDisplay;
        self.temperatureDisplay = temperatureDisplay;
        self.temperaturePosition = temperaturePosition;
        self.batteryDisplay = batteryDisplay;
        self.batteryPosition = batteryPosition;
    }
}
