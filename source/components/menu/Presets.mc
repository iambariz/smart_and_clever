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

// Every scheme is a background plus two hues: "main" (hour/minute hands -
// HourHand darkens it itself, so this is the normal-strength value - and
// every complication) and "accent" (second hand + center dot only). Accent
// is deliberately exclusive to those two rather than shared with the
// complications too - one genuinely special element reads as an accent;
// five things sharing "the loud color" doesn't. Editor-theme mains/accents
// are each pulled from that theme's own syntax-highlight palette, not
// picked to just "look nice." Accent is always a genuinely bold, distinct
// hue from main - even Monochrome/Crimson/Daylight get a real pop color
// rather than mirroring main, since a white/gray "accent" reads as no
// accent at all.
function scheme(label as ResourceId, bg as Number, main as Number, accent as Number) as Dictionary {
    return {
        :label => label,
        :values => {
            "BackgroundColor" => bg,
            "ForegroundColor" => main,
            "AccentColor" => accent,
            "TemperatureColor" => main,
            "BatteryColor" => main,
            "StepsColor" => main,
            "HeartRateColor" => main
        }
    } as Dictionary;
}

function colorSchemeList() as Array<Dictionary> {
    return [
        scheme(Rez.Strings.ColorSchemeMonochrome, 0x000000, 0xFFFFFF, 0xFFCC00),
        scheme(Rez.Strings.ColorSchemeCrimson,    0x000000, 0xFF0000, 0x00CCFF),
        scheme(Rez.Strings.ColorSchemeDaylight,   0xFFFFFF, 0x000000, 0x0066CC),
        scheme(Rez.Strings.ColorSchemeTokyoNight, 0x1A1B26, 0x7AA2F7, 0xF7768E),
        scheme(Rez.Strings.ColorSchemeDracula,    0x282A36, 0xBD93F9, 0x50FA7B),
        scheme(Rez.Strings.ColorSchemeNord,       0x2E3440, 0x88C0D0, 0xBF616A),
        scheme(Rez.Strings.ColorSchemeGruvbox,    0x282828, 0xFABD2F, 0xFB4934),
        scheme(Rez.Strings.ColorSchemeOneDark,    0x282C34, 0x61AFEF, 0xE06C75),
        scheme(Rez.Strings.ColorSchemeMonokai,    0x272822, 0xA6E22E, 0xF92672),
        scheme(Rez.Strings.ColorSchemeCatppuccin, 0x1E1E2E, 0xCBA6F7, 0xF38BA8),
        scheme(Rez.Strings.ColorSchemeSolarized,  0x002B36, 0x268BD2, 0xDC322F),
        scheme(Rez.Strings.ColorSchemeRosePine,   0x191724, 0xEBBCBA, 0x9CCFD8),
        scheme(Rez.Strings.ColorSchemeAyuDark,    0x0F1419, 0xE6B450, 0xF07178)
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
