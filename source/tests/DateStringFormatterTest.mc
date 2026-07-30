import Toybox.Test;
import Toybox.Lang;

(:test)
function testFormatDateComplicationStringBoth(logger as Test.Logger) as Boolean {
    return formatDateComplicationString("MON", 7, true, true).equals("MON 7");
}

(:test)
function testFormatDateComplicationStringDayOfWeekOnly(logger as Test.Logger) as Boolean {
    return formatDateComplicationString("MON", 7, true, false).equals("MON");
}

(:test)
function testFormatDateComplicationStringDayNumberOnly(logger as Test.Logger) as Boolean {
    return formatDateComplicationString("MON", 7, false, true).equals("7");
}

(:test)
function testFormatDateComplicationStringNeitherIsEmpty(logger as Test.Logger) as Boolean {
    return formatDateComplicationString("MON", 7, false, false).equals("");
}
