import Toybox.Lang;
import Toybox.WatchUi;

// Lists the full-face theme presets from Presets.mc, checkmarking whichever
// one currently matches every stored property. Mirrors CategoryMenu's
// shape but each row applies several properties at once instead of one.
class PresetMenu extends WatchUi.Menu2 {
    function initialize() {
        Menu2.initialize({ :title => Rez.Strings.PresetsMenuTitle });

        var presets = presetList();
        for (var i = 0; i < presets.size(); i++) {
            Menu2.addItem(new WatchUi.MenuItem(
                presets[i][:label] as ResourceId,
                isPresetActive(presets[i]) ? Rez.Strings.ValueSelected : null,
                i,
                null
            ));
        }
    }

    // Refresh checkmarks after popping back here from elsewhere, in case a
    // property was changed directly in another settings category.
    function onShow() as Void {
        var presets = presetList();
        for (var i = 0; i < presets.size(); i++) {
            var menuItem = getItem(i) as MenuItem;
            menuItem.setSubLabel(isPresetActive(presets[i]) ? Rez.Strings.ValueSelected : null);
            updateItem(menuItem, i);
        }
    }
}
