import Toybox.Application.Properties;
import Toybox.Lang;
import Toybox.WatchUi;

class PresetMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(menuItem as WatchUi.MenuItem) as Void {
        applyPreset(menuItem.getId() as Number);
        WatchUi.requestUpdate();
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }

    function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
}
