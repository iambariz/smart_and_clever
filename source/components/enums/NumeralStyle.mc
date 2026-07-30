import Toybox.Lang;

enum NumeralStyle {
    NUMERAL_STYLE_ROMAN = 0,  // I through XII
    NUMERAL_STYLE_ARABIC = 1, // 1 through 12
    NUMERAL_STYLE_NONE = 2    // plain batons, no numerals
}

function numeralStyleFromNumber(value as Number) as NumeralStyle {
    if (value == NUMERAL_STYLE_ARABIC) {
        return NUMERAL_STYLE_ARABIC;
    } else if (value == NUMERAL_STYLE_NONE) {
        return NUMERAL_STYLE_NONE;
    }
    return NUMERAL_STYLE_ROMAN;
}
