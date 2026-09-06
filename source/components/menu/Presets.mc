import Toybox.Application.Properties;
import Toybox.Lang;

// Design (shape language) and Color Scheme (palette) are independent and
// mixable - each a list of {:label, :values} dictionaries applied by name.
function designList() as Array<Dictionary> {
    return [
        {
            :label => Rez.Strings.DesignClassic,
            :values => {
                "NumeralStyle" => 0,
                "HandStyle" => 0,
                "ShowHourMarkers" => true,
                "ShowCenterDot" => true
            }
        },
        {
            :label => Rez.Strings.DesignModern,
            :values => {
                "NumeralStyle" => 1,
                "HandStyle" => 3,
                "ShowHourMarkers" => true,
                "ShowCenterDot" => true
            }
        },
        {
            :label => Rez.Strings.DesignMinimal,
            :values => {
                "NumeralStyle" => 2,
                "HandStyle" => 0,
                "ShowHourMarkers" => false,
                "ShowCenterDot" => true
            }
        },
        {
            :label => Rez.Strings.DesignBold,
            :values => {
                "NumeralStyle" => 1,
                "HandStyle" => 1,
                "ShowHourMarkers" => true,
                "ShowCenterDot" => true
            }
        },
        {
            :label => Rez.Strings.DesignSleek,
            :values => {
                "NumeralStyle" => 0,
                "HandStyle" => 2,
                "ShowHourMarkers" => true,
                "ShowCenterDot" => true
            }
        }
    ] as Array<Dictionary>;
}

// Every scheme is exactly two colors - a background and one accent shared
// by every hand (Foreground) and every complication. Settled on after
// design review: a different hue per complication read as noisy once all
// four were visible on the dial at once, while one shared accent reads as
// intentional regardless of which complications are enabled. Editor-theme
// accents are each that theme's own most iconic syntax-highlight color.
function scheme(label as ResourceId, bg as Number, accent as Number) as Dictionary {
    return {
        :label => label,
        :values => {
            "BackgroundColor" => bg,
            "ForegroundColor" => accent,
            "TemperatureColor" => accent,
            "BatteryColor" => accent,
            "StepsColor" => accent,
            "HeartRateColor" => accent
        }
    } as Dictionary;
}

function colorSchemeList() as Array<Dictionary> {
    return [
        scheme(Rez.Strings.ColorSchemeMonochrome, 0x000000, 0xFFFFFF),
        scheme(Rez.Strings.ColorSchemeCrimson,    0x000000, 0xFF0000),
        scheme(Rez.Strings.ColorSchemeDaylight,   0xFFFFFF, 0x000000),
        scheme(Rez.Strings.ColorSchemeTokyoNight, 0x1A1B26, 0x7AA2F7),
        scheme(Rez.Strings.ColorSchemeDracula,    0x282A36, 0xBD93F9),
        scheme(Rez.Strings.ColorSchemeNord,       0x2E3440, 0x88C0D0),
        scheme(Rez.Strings.ColorSchemeGruvbox,    0x282828, 0xFABD2F),
        scheme(Rez.Strings.ColorSchemeOneDark,    0x282C34, 0x61AFEF),
        scheme(Rez.Strings.ColorSchemeMonokai,    0x272822, 0xA6E22E),
        scheme(Rez.Strings.ColorSchemeCatppuccin, 0x1E1E2E, 0xCBA6F7),
        scheme(Rez.Strings.ColorSchemeSolarized,  0x002B36, 0x268BD2),
        scheme(Rez.Strings.ColorSchemeRosePine,   0x191724, 0xEBBCBA),
        scheme(Rez.Strings.ColorSchemeAyuDark,    0x0F1419, 0xE6B450)
    ] as Array<Dictionary>;
}

// Applies list[index], then records the pick in selectedProperty/
// appliedProperty so the Connect app and the on-device checkmark agree on
// what's active, and onSettingsChanged() knows not to re-apply it.
function applyPreset(list as Array<Dictionary>, index as Number, selectedProperty as String, appliedProperty as String) as Void {
    var values = list[index][:values] as Dictionary;
    var keys = values.keys();
    for (var i = 0; i < keys.size(); i++) {
        var key = keys[i] as String;
        Properties.setValue(key, values[key]);
    }
    Properties.setValue(selectedProperty, index);
    Properties.setValue(appliedProperty, index);
}

// True when every property in preset[:values] matches its stored value.
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
