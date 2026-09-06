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
                "ShowCenterDot" => false
            }
        },
        {
            :label => Rez.Strings.DesignMinimal,
            :values => {
                "NumeralStyle" => 2,
                "HandStyle" => 0,
                "ShowHourMarkers" => false,
                "ShowCenterDot" => false
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

// Every scheme sets all six color keys so switching schemes fully resets.
function colorSchemeList() as Array<Dictionary> {
    return [
        {
            :label => Rez.Strings.ColorSchemeMonochrome,
            :values => {
                "BackgroundColor" => 0x000000,
                "ForegroundColor" => 0xFFFFFF,
                "TemperatureColor" => 0xAAAAAA,
                "BatteryColor" => 0xAAAAAA,
                "StepsColor" => 0xAAAAAA,
                "HeartRateColor" => 0xAAAAAA
            }
        },
        {
            :label => Rez.Strings.ColorSchemeCrimson,
            :values => {
                "BackgroundColor" => 0x000000,
                "ForegroundColor" => 0xFF0000,
                "TemperatureColor" => 0xAAAAAA,
                "BatteryColor" => 0xAAAAAA,
                "StepsColor" => 0xAAAAAA,
                "HeartRateColor" => 0xAAAAAA
            }
        },
        {
            :label => Rez.Strings.ColorSchemeDaylight,
            :values => {
                "BackgroundColor" => 0xFFFFFF,
                "ForegroundColor" => 0x000000,
                "TemperatureColor" => 0x555555,
                "BatteryColor" => 0x555555,
                "StepsColor" => 0x555555,
                "HeartRateColor" => 0x555555
            }
        }
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
