import Toybox.Test;
import Toybox.Lang;

(:test)
function testPositionFromNumberTop(logger as Test.Logger) as Boolean {
    return positionFromNumber(0) == POSITION_TOP;
}

(:test)
function testPositionFromNumberRight(logger as Test.Logger) as Boolean {
    return positionFromNumber(1) == POSITION_RIGHT;
}

(:test)
function testPositionFromNumberBottom(logger as Test.Logger) as Boolean {
    return positionFromNumber(2) == POSITION_BOTTOM;
}

(:test)
function testPositionFromNumberLeft(logger as Test.Logger) as Boolean {
    return positionFromNumber(3) == POSITION_LEFT;
}

(:test)
function testPositionFromNumberUnknownFallsBackToBottom(logger as Test.Logger) as Boolean {
    return positionFromNumber(99) == POSITION_BOTTOM;
}
