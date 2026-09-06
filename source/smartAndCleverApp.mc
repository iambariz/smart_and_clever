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

    // A Connect-app pick only changes DesignPreset/ColorScheme itself, so
    // fan it out here the same way the on-device PresetMenu does directly.
    function onSettingsChanged() as Void {
        var selectedDesign = Properties.getValue("DesignPreset") as Number;
        if (selectedDesign != Properties.getValue("AppliedDesign") as Number) {
            applyPreset(designList(), selectedDesign, "DesignPreset", "AppliedDesign");
        }

        var selectedColorScheme = Properties.getValue("ColorScheme") as Number;
        if (selectedColorScheme != Properties.getValue("AppliedColorScheme") as Number) {
            applyPreset(colorSchemeList(), selectedColorScheme, "ColorScheme", "AppliedColorScheme");
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