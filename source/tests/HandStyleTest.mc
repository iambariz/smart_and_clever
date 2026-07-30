import Toybox.Test;
import Toybox.Lang;

(:test)
function testHandStyleFromNumberLight(logger as Test.Logger) as Boolean {
    return handStyleFromNumber(0) == HAND_STYLE_LIGHT;
}

(:test)
function testHandStyleFromNumberDauphine(logger as Test.Logger) as Boolean {
    return handStyleFromNumber(1) == HAND_STYLE_DAUPHINE;
}

(:test)
function testHandStyleFromNumberDauphineFlat(logger as Test.Logger) as Boolean {
    return handStyleFromNumber(2) == HAND_STYLE_DAUPHINE_FLAT;
}

(:test)
function testHandStyleFromNumberRectangle(logger as Test.Logger) as Boolean {
    return handStyleFromNumber(3) == HAND_STYLE_RECTANGLE;
}

(:test)
function testHandStyleFromNumberUnknownFallsBackToLight(logger as Test.Logger) as Boolean {
    return handStyleFromNumber(99) == HAND_STYLE_LIGHT;
}
