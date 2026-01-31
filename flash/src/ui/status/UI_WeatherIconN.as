package ui.status {
public class UI_WeatherIconN {
    [Embed(source="/assets/UI.swf", symbol="UI_WeatherIcon1")]
    public static var UI_WeatherIcon1:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_WeatherIcon2")]
    public static var UI_WeatherIcon2:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_WeatherIcon3")]
    public static var UI_WeatherIcon3:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_WeatherIcon4")]
    public static var UI_WeatherIcon4:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_WeatherIcon5")]
    public static var UI_WeatherIcon5:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_WeatherIcon6")]
    public static var UI_WeatherIcon6:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_WeatherIcon7")]
    public static var UI_WeatherIcon7:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_WeatherIcon8")]
    public static var UI_WeatherIcon8:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_WeatherIcon9")]
    public static var UI_WeatherIcon9:Class;

    public static function find(idx:int):Class {
        if (idx == 1) {
            return UI_WeatherIcon1;
        }
        if (idx == 2) {
            return UI_WeatherIcon2;
        }
        if (idx == 3) {
            return UI_WeatherIcon3;
        }
        if (idx == 4) {
            return UI_WeatherIcon4;
        }
        if (idx == 5) {
            return UI_WeatherIcon5;
        }
        if (idx == 6) {
            return UI_WeatherIcon6;
        }
        if (idx == 7) {
            return UI_WeatherIcon7;
        }
        if (idx == 8) {
            return UI_WeatherIcon8;
        }
        if (idx == 9) {
            return UI_WeatherIcon9;
        }
        return UI_WeatherIcon1;
    }
}
}
