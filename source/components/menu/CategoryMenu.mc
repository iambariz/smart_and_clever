import Toybox.Application.Properties;
import Toybox.Lang;
import Toybox.WatchUi;

// A settings sub-menu built from a declarative list of items - each item is
// either a boolean toggle bound directly to a property, or a row that opens
// an OptionsMenu for a Number-valued property. One generic menu class covers
// every settings category instead of a hand-written Menu2 subclass per
// category.
//
// Each item is a Dictionary shaped as:
//   { :kind => :toggle, :id => "PropertyId", :label => Rez.Strings.X }
//   { :kind => :options, :id => "PropertyId", :label => Rez.Strings.X,
//     :options => [ { :value => 0, :label => Rez.Strings.Y }, ... ] }
class CategoryMenu extends WatchUi.Menu2 {
    hidden var items as Array<Dictionary>;

    function initialize(title as ResourceId, items as Array<Dictionary>) {
        Menu2.initialize({ :title => title });
        self.items = items;

        for (var i = 0; i < items.size(); i++) {
            var item = items[i];
            if (item[:kind] == :toggle) {
                Menu2.addItem(new WatchUi.ToggleMenuItem(
                    item[:label] as ResourceId,
                    null,
                    item[:id] as String,
                    Properties.getValue(item[:id] as String) as Boolean,
                    null
                ));
            } else {
                Menu2.addItem(new WatchUi.MenuItem(
                    item[:label] as ResourceId,
                    currentOptionLabel(item),
                    item[:id] as String,
                    null
                ));
            }
        }
    }

    // Refresh every option row's sub-label - needed both on first show and
    // when popping back here after picking a new value in an OptionsMenu.
    function onShow() as Void {
        for (var i = 0; i < items.size(); i++) {
            var item = items[i];
            if (item[:kind] != :options) {
                continue;
            }

            var index = findItemById(item[:id] as String);
            var menuItem = getItem(index) as MenuItem;
            menuItem.setSubLabel(currentOptionLabel(item));
            updateItem(menuItem, index);
        }
    }

    hidden function currentOptionLabel(item as Dictionary) as ResourceId? {
        var current = Properties.getValue(item[:id] as String) as Number;
        var options = item[:options] as Array<Dictionary>;
        for (var i = 0; i < options.size(); i++) {
            if (options[i][:value] == current) {
                return options[i][:label] as ResourceId;
            }
        }
        return null;
    }
}
