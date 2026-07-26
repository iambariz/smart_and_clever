import Toybox.Graphics;
import Toybox.Lang;

module DialGeometry {
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
}
