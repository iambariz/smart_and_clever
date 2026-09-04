import Toybox.Lang;

// Blends `from` toward `to` by `amount` (0 = from, 1 = to) per RGB channel.
// Used to derive a "subtle" variant of a theme's foreground color by
// blending it toward the background, so secondary elements (like the date
// box) dim in whichever direction fits the active theme - toward black on
// a dark face, toward white on a light one - instead of a fixed gray that
// only reads correctly against one background.
function mixColor(from as Number, to as Number, amount as Float) as Number {
    var fromRed = (from >> 16) & 0xFF;
    var fromGreen = (from >> 8) & 0xFF;
    var fromBlue = from & 0xFF;
    var toRed = (to >> 16) & 0xFF;
    var toGreen = (to >> 8) & 0xFF;
    var toBlue = to & 0xFF;

    var red = (fromRed + (toRed - fromRed) * amount).toNumber();
    var green = (fromGreen + (toGreen - fromGreen) * amount).toNumber();
    var blue = (fromBlue + (toBlue - fromBlue) * amount).toNumber();

    return (red << 16) | (green << 8) | blue;
}
