import Toybox.Application;
import Toybox.Application.Properties;
import Toybox.Lang;
import Toybox.WatchUi;

class smartAndCleverApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new smartAndCleverView() ];
    }

    // New app settings have been received so trigger a UI update. Also
    // covers the Connect app's "Theme Preset" list: unlike the on-device
    // PresetMenu (which calls applyPreset() directly on selection), picking
    // a preset from the phone/web app only changes the ThemePreset
    // property itself - so fan it out to the underlying color/hand/numeral
    // properties here. Compared against AppliedPreset (an internal
    // property with no settings.xml entry, so it never shows in the app UI)
    // to avoid re-applying the same preset - and clobbering any properties
    // the user tweaked individually since - on every unrelated settings
    // change.
    function onSettingsChanged() as Void {
        var selected = Properties.getValue("ThemePreset") as Number;
        var applied = Properties.getValue("AppliedPreset") as Number;
        if (selected != applied) {
            applyPreset(selected);
        }
        WatchUi.requestUpdate();
    }

    // On-device settings menu, reachable without the Connect Mobile app.
    function getSettingsView() as [Views] or [Views, InputDelegates] or Null {
        return [ new SettingsMenu(), new SettingsMenuDelegate() ];
    }

}

function getApp() as smartAndCleverApp {
    return Application.getApp() as smartAndCleverApp;
}