import Toybox.Application.Properties;
import Toybox.Lang;
import Toybox.WatchUi;

class CategoryMenuDelegate extends WatchUi.Menu2InputDelegate {
    hidden var items as Array<Dictionary>;

    function initialize(items as Array<Dictionary>) {
        Menu2InputDelegate.initialize();
        self.items = items;
    }

    function onSelect(menuItem as WatchUi.MenuItem) as Void {
        var id = menuItem.getId() as String;
        var item = findItem(id);
        if (item == null) {
            return;
        }

        if (item[:kind] == :toggle) {
            Properties.setValue(id, !(Properties.getValue(id) as Boolean));
            WatchUi.requestUpdate();
        } else {
            WatchUi.pushView(
                new OptionsMenu(item[:label] as ResourceId, id, item[:options] as Array<Dictionary>),
                new OptionsMenuDelegate(id),
                WatchUi.SLIDE_LEFT
            );
        }
    }

    function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }

    hidden function findItem(id as String) as Dictionary? {
        for (var i = 0; i < items.size(); i++) {
            if ((items[i][:id] as String).equals(id)) {
                return items[i];
            }
        }
        return null;
    }
}
