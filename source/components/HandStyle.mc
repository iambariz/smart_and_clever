import Toybox.Lang;

// Visual preset for the hour/minute hands. "Dauphine" is the real
// watchmaking term for broad, flat-sided hands that taper to a point
// (like the reference Rolex Day-Date) - bolder than the thin default.
enum HandStyle {
    HAND_STYLE_LIGHT = 0,
    HAND_STYLE_DAUPHINE = 1
}

function handStyleFromNumber(value as Number) as HandStyle {
    if (value == HAND_STYLE_DAUPHINE) {
        return HAND_STYLE_DAUPHINE;
    }
    return HAND_STYLE_LIGHT;
}
