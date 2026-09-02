import Toybox.Lang;

// Base for any dial element placed at one of the four cardinal Positions
// (see DialGeometry.pointForPosition). Adds position-collision suppression
// on top of WatchFaceElement's plain show/hide: with only 4 slots and more
// than 4 optional complications, two enabled at the same position would
// otherwise draw stacked on top of each other. Background resolves
// collisions once per draw and suppresses all but the first (priority
// order) claimant of a given slot.
class PositionedComplication extends WatchFaceElement {
    var position as Position;
    var suppressed as Boolean;

    function initialize(displayStyle as DisplayStyle, position as Position) {
        WatchFaceElement.initialize(displayStyle);
        self.position = position;
        suppressed = false;
    }

    function suppress() as Void {
        suppressed = true;
    }

    function isVisible() as Boolean {
        return WatchFaceElement.isVisible() && !suppressed;
    }
}
