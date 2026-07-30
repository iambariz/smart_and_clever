import Toybox.Lang;

// Generic cardinal placement, reusable by any element that needs a
// configurable position (temperature now, others later).
enum Position {
    POSITION_TOP = 0,
    POSITION_RIGHT = 1,
    POSITION_BOTTOM = 2,
    POSITION_LEFT = 3
}

function positionFromNumber(value as Number) as Position {
    if (value == POSITION_TOP) {
        return POSITION_TOP;
    } else if (value == POSITION_RIGHT) {
        return POSITION_RIGHT;
    } else if (value == POSITION_LEFT) {
        return POSITION_LEFT;
    }
    return POSITION_BOTTOM;
}
