import Toybox.Application;
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

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() as Void {
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