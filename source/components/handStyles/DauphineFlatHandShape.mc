import Toybox.Lang;

// Same faceted taper as DauphineHandShape, but ending in a blunt/chisel
class DauphineFlatHandShape extends FacetedHandShape {
    function initialize() {
        FacetedHandShape.initialize();
    }

    function tipWidthFor(width as Number) as Number {
        return (width * 0.35 * 0.4).toNumber();
    }
}
