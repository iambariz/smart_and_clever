import Toybox.Lang;

// Visual preset for the hour/minute hands. "Dauphine" is the real
// watchmaking term for broad, faceted hands with a sharp break partway
// along tapering to a point (like the reference Rolex Day-Date); the flat
// variant has the same faceted break but ends in a blunt/chisel tip
// instead of a sharp point. "Rectangle" is a plain constant-width bar with
// no taper at all.
enum HandStyle {
    HAND_STYLE_LIGHT = 0,
    HAND_STYLE_DAUPHINE = 1,
    HAND_STYLE_DAUPHINE_FLAT = 2,
    HAND_STYLE_RECTANGLE = 3
}

function handStyleFromNumber(value as Number) as HandStyle {
    if (value == HAND_STYLE_DAUPHINE) {
        return HAND_STYLE_DAUPHINE;
    } else if (value == HAND_STYLE_DAUPHINE_FLAT) {
        return HAND_STYLE_DAUPHINE_FLAT;
    } else if (value == HAND_STYLE_RECTANGLE) {
        return HAND_STYLE_RECTANGLE;
    }
    return HAND_STYLE_LIGHT;
}
