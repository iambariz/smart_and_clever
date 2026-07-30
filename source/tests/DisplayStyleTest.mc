import Toybox.Test;
import Toybox.Lang;

(:test)
function testDisplayStyleFromBooleanTrue(logger as Test.Logger) as Boolean {
    return displayStyleFromBoolean(true) == DISPLAY_SHOWN;
}

(:test)
function testDisplayStyleFromBooleanFalse(logger as Test.Logger) as Boolean {
    return displayStyleFromBoolean(false) == DISPLAY_HIDDEN;
}
