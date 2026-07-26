import Toybox.Lang;

// Plain data holder (DTO) for user-configurable display options. It has no
// behavior of its own - something builds one from the app's Properties,
// elements just read values back out of it.
class WatchFaceConfig {
    var numeralStyle as NumeralStyle;

    function initialize(numeralStyle as NumeralStyle) {
        self.numeralStyle = numeralStyle;
    }
}
