import Toybox.Lang;

// Whether a dial element should be drawn at all. Generic across every
// element - Background just skips draw() for anything set to HIDDEN.
enum DisplayStyle {
    DISPLAY_HIDDEN = 0,
    DISPLAY_SHOWN = 1
}

// This one is a natural on/off toggle, so its property is stored as a plain
// Boolean rather than a Number (unlike NumeralStyle's multi-way list).
function displayStyleFromBoolean(value as Boolean) as DisplayStyle {
    return value ? DISPLAY_SHOWN : DISPLAY_HIDDEN;
}
