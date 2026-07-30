import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;

module DialGeometry {
    // Converts a clock-face degree value (0 = 12 o'clock, clockwise) to the
    // radians dc drawing calls expect (0 = 3 o'clock). Shared by anything
    // that places itself around the dial by hour/minute angle.
    function clockAngle(degrees as Numeric) as Float {
        return (degrees - 90) * Math.PI / 180.0;
    }

    function centerX(dc as Dc) as Number {
        return dc.getWidth() / 2;
    }

    function centerY(dc as Dc) as Number {
        return dc.getHeight() / 2;
    }

    function radius(dc as Dc) as Number {
        var width = dc.getWidth();
        var height = dc.getHeight();
        return (width < height ? width : height) / 2 - 20;
    }

    // A point offset from center toward one of the four cardinal Positions -
    // shared by any element that needs a configurable placement.
    function pointForPosition(dc as Dc, position as Position, offset as Float) as Array<Numeric> {
        var x = centerX(dc);
        var y = centerY(dc);

        if (position == POSITION_TOP) {
            return [x, y - offset];
        } else if (position == POSITION_RIGHT) {
            return [x + offset, y];
        } else if (position == POSITION_LEFT) {
            return [x - offset, y];
        }
        return [x, y + offset];
    }
}
