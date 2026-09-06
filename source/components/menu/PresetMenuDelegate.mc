import Toybox.Application.Properties;
import Toybox.Lang;
import Toybox.WatchUi;

class PresetMenuDelegate extends WatchUi.Menu2InputDelegate {
    hidden var list as Array<Dictionary>;
    hidden var selectedProperty as String;
    hidden var appliedProperty as String;

    function initialize(list as Array<Dictionary>, selectedProperty as String, appliedProperty as String) {
        Menu2InputDelegate.initialize();
        self.list = list;
        self.selectedProperty = selectedProperty;
        self.appliedProperty = appliedProperty;
    }

    function onSelect(menuItem as WatchUi.MenuItem) as Void {
        applyPreset(list, menuItem.getId() as Number, selectedProperty, appliedProperty);
        WatchUi.requestUpdate();
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }

    function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
}
