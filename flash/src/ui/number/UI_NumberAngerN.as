package ui.number {
public class UI_NumberAngerN {
    [Embed(source="/assets/UI.swf", symbol="UI_NumberAnger0")]
    public static var UI_NumberAnger0:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberAnger1")]
    public static var UI_NumberAnger1:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberAnger2")]
    public static var UI_NumberAnger2:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberAnger3")]
    public static var UI_NumberAnger3:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberAnger4")]
    public static var UI_NumberAnger4:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberAnger5")]
    public static var UI_NumberAnger5:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberAnger6")]
    public static var UI_NumberAnger6:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberAnger7")]
    public static var UI_NumberAnger7:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberAnger8")]
    public static var UI_NumberAnger8:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberAnger9")]
    public static var UI_NumberAnger9:Class;

    public static function find(idx:int):Class {
        if (idx == 0) {
            return UI_NumberAnger0;
        }
        if (idx == 1) {
            return UI_NumberAnger1;
        }
        if (idx == 2) {
            return UI_NumberAnger2;
        }
        if (idx == 3) {
            return UI_NumberAnger3;
        }
        if (idx == 4) {
            return UI_NumberAnger4;
        }
        if (idx == 5) {
            return UI_NumberAnger5;
        }
        if (idx == 6) {
            return UI_NumberAnger6;
        }
        if (idx == 7) {
            return UI_NumberAnger7;
        }
        if (idx == 8) {
            return UI_NumberAnger8;
        }
        if (idx == 9) {
            return UI_NumberAnger9;
        }
        return UI_NumberAnger0;
    }
}
}
