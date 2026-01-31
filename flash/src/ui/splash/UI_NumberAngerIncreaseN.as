package ui.splash {
public class UI_NumberAngerIncreaseN {
    [Embed(source="/assets/UI.swf", symbol="UI_NumberAngerIncrease0")]
    public static var UI_NumberAngerIncrease0:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberAngerIncrease1")]
    public static var UI_NumberAngerIncrease1:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberAngerIncrease2")]
    public static var UI_NumberAngerIncrease2:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberAngerIncrease3")]
    public static var UI_NumberAngerIncrease3:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberAngerIncrease4")]
    public static var UI_NumberAngerIncrease4:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberAngerIncrease5")]
    public static var UI_NumberAngerIncrease5:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberAngerIncrease6")]
    public static var UI_NumberAngerIncrease6:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberAngerIncrease7")]
    public static var UI_NumberAngerIncrease7:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberAngerIncrease8")]
    public static var UI_NumberAngerIncrease8:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberAngerIncrease9")]
    public static var UI_NumberAngerIncrease9:Class;

    public static function find(idx:int):Class {
        if (idx == 0) {
            return UI_NumberAngerIncrease0;
        }
        if (idx == 1) {
            return UI_NumberAngerIncrease1;
        }
        if (idx == 2) {
            return UI_NumberAngerIncrease2;
        }
        if (idx == 3) {
            return UI_NumberAngerIncrease3;
        }
        if (idx == 4) {
            return UI_NumberAngerIncrease4;
        }
        if (idx == 5) {
            return UI_NumberAngerIncrease5;
        }
        if (idx == 6) {
            return UI_NumberAngerIncrease6;
        }
        if (idx == 7) {
            return UI_NumberAngerIncrease7;
        }
        if (idx == 8) {
            return UI_NumberAngerIncrease8;
        }
        if (idx == 9) {
            return UI_NumberAngerIncrease9;
        }
        return UI_NumberAngerIncrease0;
    }
}
}
