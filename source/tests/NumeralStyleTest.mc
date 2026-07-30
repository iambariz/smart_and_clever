import Toybox.Test;
import Toybox.Lang;

(:test)
function testNumeralStyleFromNumberRoman(logger as Test.Logger) as Boolean {
    return numeralStyleFromNumber(0) == NUMERAL_STYLE_ROMAN;
}

(:test)
function testNumeralStyleFromNumberArabic(logger as Test.Logger) as Boolean {
    return numeralStyleFromNumber(1) == NUMERAL_STYLE_ARABIC;
}

(:test)
function testNumeralStyleFromNumberNone(logger as Test.Logger) as Boolean {
    return numeralStyleFromNumber(2) == NUMERAL_STYLE_NONE;
}

(:test)
function testNumeralStyleFromNumberUnknownFallsBackToRoman(logger as Test.Logger) as Boolean {
    logger.debug("An out-of-range property value should degrade to the Roman default, not crash");
    return numeralStyleFromNumber(99) == NUMERAL_STYLE_ROMAN;
}
