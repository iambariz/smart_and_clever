import Toybox.Graphics;
import Toybox.Lang;

// Common contract for anything drawn onto the dial. Monkey C has no
// `interface` keyword, so a base class with an overridable method is the
// equivalent here: every element gets composed and drawn the same way, and
// every element carries a DisplayStyle so Background can skip hidden ones
// generically instead of each element checking its own visibility.
class WatchFaceElement {
    var displayStyle as DisplayStyle;

    function initialize(displayStyle as DisplayStyle) {
        self.displayStyle = displayStyle;
    }

    function isVisible() as Boolean {
        return displayStyle == DISPLAY_SHOWN;
    }

    function draw(dc as Dc) as Void {
    }
}
