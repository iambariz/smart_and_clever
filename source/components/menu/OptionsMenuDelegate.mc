import Toybox.Application.Properties;
import Toybox.Lang;
import Toybox.WatchUi;

class OptionsMenuDelegate extends WatchUi.Menu2InputDelegate {
    hidden var propertyId as String;

    function initialize(propertyId as String) {
        Menu2InputDelegate.initialize();
        self.propertyId = propertyId;
    }

    function onSelect(menuItem as WatchUi.MenuItem) as Void {
        Properties.setValue(propertyId, menuItem.getId() as Number);
        WatchUi.requestUpdate();
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }

    function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
}
