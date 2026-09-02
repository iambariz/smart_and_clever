import Toybox.Application.Properties;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Timer;
import Toybox.WatchUi;

class smartAndCleverView extends WatchUi.WatchFace {
    var secondsTimer as Timer.Timer;
    var isAwake as Boolean;
    var secondsTimerRunning as Boolean;

    function initialize() {
        WatchFace.initialize();
        secondsTimer = new Timer.Timer();
        isAwake = true;
        secondsTimerRunning = false;
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        reconcileSecondsTimer();
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Reconciled here too (not just on the sleep/show lifecycle calls)
        // so toggling "Show Second Hand" in settings while the face is on
        // screen starts/stops the ticking immediately.
        reconcileSecondsTimer();
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        stopSecondsTimer();
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
        isAwake = true;
        reconcileSecondsTimer();
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
        isAwake = false;
        stopSecondsTimer();
    }

    // Lets the OS keep the face on screen in Always-On mode instead of
    // blanking/dimming on wrist-down. The OS decides how often this is
    // called during sleep (never faster than once/second, often once a
    // minute on AMOLED to limit burn-in) - we just draw whatever the clock
    // says right now each time, same as a normal update. Safe to reuse the
    // full draw here since the second-hand timer above is already stopped
    // for sleep, so there's nothing per-second-precise to reconcile.
    function onPartialUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
    }

    // Garmin only redraws watch faces once a minute by default; a sweeping
    // second hand needs a 1Hz timer requesting updates instead. Only runs
    // while awake and enabled, since redrawing every second in always-on/
    // sleep mode (or when the hand is hidden) would just burn battery.
    function reconcileSecondsTimer() as Void {
        var shouldRun = isAwake && (Properties.getValue("ShowSecondHand") as Boolean);
        if (shouldRun == secondsTimerRunning) {
            return;
        }
        secondsTimerRunning = shouldRun;
        if (shouldRun) {
            secondsTimer.start(method(:onSecondsTick), 1000, true);
        } else {
            secondsTimer.stop();
        }
    }

    function stopSecondsTimer() as Void {
        if (secondsTimerRunning) {
            secondsTimerRunning = false;
            secondsTimer.stop();
        }
    }

    function onSecondsTick() as Void {
        WatchUi.requestUpdate();
    }

}
