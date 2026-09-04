import Toybox.Application.Properties;
import Toybox.Lang;

// Shared data for full-face theme presets, used by both PresetMenu (to
// render the list and show which one is currently active) and
// PresetMenuDelegate (to apply one). Each preset bundles the "look"
// properties - colors, numerals, hand style, hour markers, center dot -
// deliberately leaving complication layout (date/battery/steps/heart
// rate) untouched, since that's a per-user placement choice rather than
// part of a visual theme.
function presetList() as Array<Dictionary> {
    return [
        {
            :label => Rez.Strings.PresetClassic,
            :values => {
                "BackgroundColor" => 0x000000,
                "ForegroundColor" => 0xFFFFFF,
                "NumeralStyle" => 0,
                "HandStyle" => 0,
                "ShowHourMarkers" => true,
                "ShowCenterDot" => true
            }
        },
        {
            :label => Rez.Strings.PresetModern,
            :values => {
                "BackgroundColor" => 0x000000,
                "ForegroundColor" => 0xFFFFFF,
                "NumeralStyle" => 1,
                "HandStyle" => 3,
                "ShowHourMarkers" => true,
                "ShowCenterDot" => false
            }
        },
        {
            :label => Rez.Strings.PresetMinimal,
            :values => {
                "BackgroundColor" => 0x000000,
                "ForegroundColor" => 0xFFFFFF,
                "NumeralStyle" => 2,
                "HandStyle" => 0,
                "ShowHourMarkers" => false,
                "ShowCenterDot" => false
            }
        },
        {
            :label => Rez.Strings.PresetBold,
            :values => {
                "BackgroundColor" => 0x000000,
                "ForegroundColor" => 0xFF0000,
                "NumeralStyle" => 1,
                "HandStyle" => 1,
                "ShowHourMarkers" => true,
                "ShowCenterDot" => true
            }
        },
        {
            :label => Rez.Strings.PresetDaylight,
            :values => {
                "BackgroundColor" => 0xFFFFFF,
                "ForegroundColor" => 0x000000,
                "NumeralStyle" => 0,
                "HandStyle" => 2,
                "ShowHourMarkers" => true,
                "ShowCenterDot" => true
            }
        }
    ] as Array<Dictionary>;
}

// Writes every property in presets[index][:values], then records index in
// both the user-facing "ThemePreset" setting and the internal
// "AppliedPreset" bookkeeping property - so the Connect app's dropdown and
// the on-device menu's checkmark both reflect whichever side picked last,
// and onSettingsChanged() (see smartAndCleverApp.mc) knows not to re-apply
// a preset that's already in effect.
function applyPreset(index as Number) as Void {
    var values = presetList()[index][:values] as Dictionary;
    var keys = values.keys();
    for (var i = 0; i < keys.size(); i++) {
        var key = keys[i] as String;
        Properties.setValue(key, values[key]);
    }
    Properties.setValue("ThemePreset", index);
    Properties.setValue("AppliedPreset", index);
}

// True when every property in preset[:values] currently matches its
// stored value - used to mark the active theme with a checkmark, and to
// leave it unmarked once the user tweaks a single property away from it.
function isPresetActive(preset as Dictionary) as Boolean {
    var values = preset[:values] as Dictionary;
    var keys = values.keys();
    for (var i = 0; i < keys.size(); i++) {
        var key = keys[i] as String;
        if (!(Properties.getValue(key).equals(values[key]))) {
            return false;
        }
    }
    return true;
}
