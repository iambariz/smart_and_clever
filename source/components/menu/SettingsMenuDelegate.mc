import Toybox.Lang;
import Toybox.WatchUi;

class SettingsMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(menuItem as WatchUi.MenuItem) as Void {
        var id = menuItem.getId() as String;

        if (id.equals("Presets")) {
            WatchUi.pushView(new PresetMenu(), new PresetMenuDelegate(), WatchUi.SLIDE_LEFT);
            return;
        }

        var title = titleFor(id);
        var items = itemsFor(id);
        if (title == null || items == null) {
            return;
        }

        WatchUi.pushView(
            new CategoryMenu(title, items),
            new CategoryMenuDelegate(items),
            WatchUi.SLIDE_LEFT
        );
    }

    function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }

    hidden function titleFor(id as String) as ResourceId? {
        switch (id) {
            case "Colors":
                return Rez.Strings.ColorsMenuTitle;
            case "Hands":
                return Rez.Strings.HandsMenuTitle;
            case "Date":
                return Rez.Strings.DateMenuTitle;
            case "Complications":
                return Rez.Strings.ComplicationsMenuTitle;
            default:
                return null;
        }
    }

    hidden function itemsFor(id as String) as Array<Dictionary>? {
        switch (id) {
            case "Colors":
                return [
                    {
                        :kind => :options,
                        :id => "BackgroundColor",
                        :label => Rez.Strings.BackgroundColorTitle,
                        :options => [
                            { :value => 0x000000, :label => Rez.Strings.ColorBlack },
                            { :value => 0x555555, :label => Rez.Strings.ColorDarkGray },
                            { :value => 0xAAAAAA, :label => Rez.Strings.ColorLightGray },
                            { :value => 0xFFFFFF, :label => Rez.Strings.ColorWhite }
                        ]
                    },
                    {
                        :kind => :options,
                        :id => "ForegroundColor",
                        :label => Rez.Strings.ForegroundColorTitle,
                        :options => [
                            { :value => 0x000000, :label => Rez.Strings.ColorBlack },
                            { :value => 0x0000FF, :label => Rez.Strings.ColorBlue },
                            { :value => 0xFF0000, :label => Rez.Strings.ColorRed },
                            { :value => 0xFFFFFF, :label => Rez.Strings.ColorWhite }
                        ]
                    }
                ] as Array<Dictionary>;

            case "Hands":
                return [
                    {
                        :kind => :options,
                        :id => "NumeralStyle",
                        :label => Rez.Strings.NumeralStyleTitle,
                        :options => [
                            { :value => 0, :label => Rez.Strings.NumeralsRoman },
                            { :value => 1, :label => Rez.Strings.NumeralsArabic },
                            { :value => 2, :label => Rez.Strings.NumeralsNone }
                        ]
                    },
                    {
                        :kind => :options,
                        :id => "HandStyle",
                        :label => Rez.Strings.HandStyleTitle,
                        :options => [
                            { :value => 0, :label => Rez.Strings.HandStyleLight },
                            { :value => 1, :label => Rez.Strings.HandStyleDauphine },
                            { :value => 2, :label => Rez.Strings.HandStyleDauphineFlat },
                            { :value => 3, :label => Rez.Strings.HandStyleRectangle }
                        ]
                    },
                    { :kind => :toggle, :id => "ShowHourMarkers", :label => Rez.Strings.ShowHourMarkersTitle },
                    { :kind => :toggle, :id => "ShowHourHand", :label => Rez.Strings.ShowHourHandTitle },
                    { :kind => :toggle, :id => "ShowMinuteHand", :label => Rez.Strings.ShowMinuteHandTitle },
                    { :kind => :toggle, :id => "ShowSecondHand", :label => Rez.Strings.ShowSecondHandTitle },
                    { :kind => :toggle, :id => "ShowCenterDot", :label => Rez.Strings.ShowCenterDotTitle }
                ] as Array<Dictionary>;

            case "Date":
                return [
                    { :kind => :toggle, :id => "ShowDateComplication", :label => Rez.Strings.ShowDateComplicationTitle },
                    { :kind => :toggle, :id => "ShowDayOfWeek", :label => Rez.Strings.ShowDayOfWeekTitle },
                    { :kind => :toggle, :id => "ShowDayNumber", :label => Rez.Strings.ShowDayNumberTitle },
                    { :kind => :toggle, :id => "ShowDateBorder", :label => Rez.Strings.ShowDateBorderTitle }
                ] as Array<Dictionary>;

            case "Complications":
                return [
                    { :kind => :toggle, :id => "ShowTemperature", :label => Rez.Strings.ShowTemperatureTitle },
                    { :kind => :options, :id => "TemperaturePosition", :label => Rez.Strings.TemperaturePositionTitle, :options => positionOptions() },
                    { :kind => :toggle, :id => "ShowBattery", :label => Rez.Strings.ShowBatteryTitle },
                    { :kind => :options, :id => "BatteryPosition", :label => Rez.Strings.BatteryPositionTitle, :options => positionOptions() },
                    { :kind => :toggle, :id => "ShowSteps", :label => Rez.Strings.ShowStepsTitle },
                    { :kind => :options, :id => "StepsPosition", :label => Rez.Strings.StepsPositionTitle, :options => positionOptions() },
                    { :kind => :toggle, :id => "ShowHeartRate", :label => Rez.Strings.ShowHeartRateTitle },
                    { :kind => :options, :id => "HeartRatePosition", :label => Rez.Strings.HeartRatePositionTitle, :options => positionOptions() }
                ] as Array<Dictionary>;

            default:
                return null;
        }
    }

    // The 4 cardinal slots - shared by every position-type complication
    // (Temperature/Battery/Steps/HeartRate), matching settings.xml's
    // Position listEntry values exactly.
    hidden function positionOptions() as Array<Dictionary> {
        return [
            { :value => 0, :label => Rez.Strings.PositionTop },
            { :value => 1, :label => Rez.Strings.PositionRight },
            { :value => 2, :label => Rez.Strings.PositionBottom },
            { :value => 3, :label => Rez.Strings.PositionLeft }
        ] as Array<Dictionary>;
    }
}
