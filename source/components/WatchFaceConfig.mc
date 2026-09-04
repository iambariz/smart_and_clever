import Toybox.Lang;

// Plain data holder (DTO) for user-configurable display options. It has no
// behavior of its own - Background sets each field by name from the app's
// Properties, elements just read values back out of it.
//
// Deliberately no constructor arguments: a positional constructor here
// used to take 13 arguments, several sharing the same DisplayStyle type,
// which meant two adjacent lines could be swapped and the compiler would
// never catch it (both sides type-check as DisplayStyle) - it would just
// silently wire the wrong setting to the wrong element. Setting fields by
// name instead makes that class of mistake impossible: each assignment
// names its own field, so reordering or deleting one can't cross-wire
// another. Every field has an inline default so nothing is ever left
// unset even if a future property is forgotten at the call site.
class WatchFaceConfig {
    var numeralStyle as NumeralStyle = NUMERAL_STYLE_ROMAN;
    var foregroundColor as Number = 0xFFFFFF;
    var hourMarkersDisplay as DisplayStyle = DISPLAY_SHOWN;
    var hourHandDisplay as DisplayStyle = DISPLAY_SHOWN;
    var minuteHandDisplay as DisplayStyle = DISPLAY_SHOWN;
    var secondHandDisplay as DisplayStyle = DISPLAY_SHOWN;
    var handStyle as HandStyle = HAND_STYLE_LIGHT;
    var centerDotDisplay as DisplayStyle = DISPLAY_SHOWN;
    var dateDisplay as DisplayStyle = DISPLAY_SHOWN;
    var dayOfWeekDisplay as DisplayStyle = DISPLAY_SHOWN;
    var dayNumberDisplay as DisplayStyle = DISPLAY_SHOWN;
    var dateBorderDisplay as DisplayStyle = DISPLAY_SHOWN;
    var temperatureDisplay as DisplayStyle = DISPLAY_SHOWN;
    var temperaturePosition as Position = POSITION_LEFT;
    var batteryDisplay as DisplayStyle = DISPLAY_SHOWN;
    var batteryPosition as Position = POSITION_TOP;
    var stepsDisplay as DisplayStyle = DISPLAY_SHOWN;
    var stepsPosition as Position = POSITION_BOTTOM;
    var heartRateDisplay as DisplayStyle = DISPLAY_HIDDEN;
    var heartRatePosition as Position = POSITION_LEFT;

    function initialize() {
    }
}
