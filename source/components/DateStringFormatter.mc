import Toybox.Lang;

// Pure formatting logic extracted from DateComplication so it's testable
// without depending on the current date/time.
function formatDateComplicationString(dayOfWeek as String, dayNumber as Number, showDayOfWeek as Boolean, showDayNumber as Boolean) as String {
    if (showDayOfWeek && showDayNumber) {
        return Lang.format("$1$ $2$", [dayOfWeek, dayNumber]);
    } else if (showDayOfWeek) {
        return dayOfWeek;
    } else if (showDayNumber) {
        return dayNumber.format("%d");
    }
    return "";
}
