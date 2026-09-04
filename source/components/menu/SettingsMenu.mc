import Toybox.Lang;
import Toybox.WatchUi;

// Top-level on-device settings menu, reachable via AppBase.getSettingsView().
// Fixed set of category rows; each one's contents live in
// SettingsMenuDelegate, which builds the matching CategoryMenu on selection.
class SettingsMenu extends WatchUi.Menu2 {
    function initialize() {
        Menu2.initialize({ :title => Rez.Strings.SettingsMenuTitle });
        Menu2.addItem(new WatchUi.MenuItem(Rez.Strings.ColorsMenuTitle, null, "Colors", null));
        Menu2.addItem(new WatchUi.MenuItem(Rez.Strings.HandsMenuTitle, null, "Hands", null));
        Menu2.addItem(new WatchUi.MenuItem(Rez.Strings.DateMenuTitle, null, "Date", null));
        Menu2.addItem(new WatchUi.MenuItem(Rez.Strings.ComplicationsMenuTitle, null, "Complications", null));
    }
}
