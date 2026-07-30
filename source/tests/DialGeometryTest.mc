import Toybox.Test;
import Toybox.Lang;
import Toybox.Math;

(:test)
function testClockAngleAtTwelve(logger as Test.Logger) as Boolean {
    // 0 degrees on a clock face (12 o'clock) should point straight up,
    // which in dc drawing coordinates is -PI/2 (0 = 3 o'clock, clockwise).
    return nearlyEqual(DialGeometry.clockAngle(0), -Math.PI / 2.0);
}

(:test)
function testClockAngleAtThree(logger as Test.Logger) as Boolean {
    return nearlyEqual(DialGeometry.clockAngle(90), 0.0);
}

(:test)
function testClockAngleAtSix(logger as Test.Logger) as Boolean {
    return nearlyEqual(DialGeometry.clockAngle(180), Math.PI / 2.0);
}

(:test)
function testClockAngleAtNine(logger as Test.Logger) as Boolean {
    return nearlyEqual(DialGeometry.clockAngle(270), Math.PI);
}

function nearlyEqual(a as Float, b as Float) as Boolean {
    var diff = a - b;
    if (diff < 0) {
        diff = -diff;
    }
    return diff < 0.0001;
}
