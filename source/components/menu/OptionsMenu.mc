import Toybox.Application.Properties;
import Toybox.Lang;
import Toybox.WatchUi;

// Generic single-choice picker for any Number-valued property (colors,
// numeral/hand style, cardinal position) - one class instead of a
// hand-written Menu2 per list-type property.
class OptionsMenu extends WatchUi.Menu2 {
    function initialize(title as ResourceId, propertyId as String, options as Array<Dictionary>) {
        Menu2.initialize({ :title => title });

        var current = Properties.getValue(propertyId) as Number;
        for (var i = 0; i < options.size(); i++) {
            var value = options[i][:value] as Number;
            Menu2.addItem(new WatchUi.MenuItem(
                options[i][:label] as ResourceId,
                value == current ? Rez.Strings.ValueSelected : null,
                value,
                null
            ));
            if (value == current) {
                Menu2.setFocus(i);
            }
        }
    }
}
