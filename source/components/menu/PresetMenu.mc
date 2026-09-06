import Toybox.Lang;
import Toybox.WatchUi;

// Renders any preset list from Presets.mc, checkmarking the active one.
class PresetMenu extends WatchUi.Menu2 {
    hidden var list as Array<Dictionary>;

    function initialize(title as ResourceId, list as Array<Dictionary>) {
        Menu2.initialize({ :title => title });
        self.list = list;

        for (var i = 0; i < list.size(); i++) {
            Menu2.addItem(new WatchUi.MenuItem(
                list[i][:label] as ResourceId,
                isPresetActive(list[i]) ? Rez.Strings.ValueSelected : null,
                i,
                null
            ));
        }
    }

    // Refresh checkmarks in case a property changed in another menu.
    function onShow() as Void {
        for (var i = 0; i < list.size(); i++) {
            var menuItem = getItem(i) as MenuItem;
            menuItem.setSubLabel(isPresetActive(list[i]) ? Rez.Strings.ValueSelected : null);
            updateItem(menuItem, i);
        }
    }
}
