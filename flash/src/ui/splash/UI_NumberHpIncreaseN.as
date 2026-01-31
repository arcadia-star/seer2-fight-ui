package ui.splash {
public class UI_NumberHpIncreaseN {
    [Embed(source="/assets/UI.swf", symbol="UI_NumberHpIncrease0")]
    public static var UI_NumberHpIncrease0:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberHpIncrease1")]
    public static var UI_NumberHpIncrease1:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberHpIncrease2")]
    public static var UI_NumberHpIncrease2:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberHpIncrease3")]
    public static var UI_NumberHpIncrease3:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberHpIncrease4")]
    public static var UI_NumberHpIncrease4:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberHpIncrease5")]
    public static var UI_NumberHpIncrease5:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberHpIncrease6")]
    public static var UI_NumberHpIncrease6:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberHpIncrease7")]
    public static var UI_NumberHpIncrease7:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberHpIncrease8")]
    public static var UI_NumberHpIncrease8:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberHpIncrease9")]
    public static var UI_NumberHpIncrease9:Class;

    public static function find(idx:int):Class {
        if (idx == 0) {
            return UI_NumberHpIncrease0;
        }
        if (idx == 1) {
            return UI_NumberHpIncrease1;
        }
        if (idx == 2) {
            return UI_NumberHpIncrease2;
        }
        if (idx == 3) {
            return UI_NumberHpIncrease3;
        }
        if (idx == 4) {
            return UI_NumberHpIncrease4;
        }
        if (idx == 5) {
            return UI_NumberHpIncrease5;
        }
        if (idx == 6) {
            return UI_NumberHpIncrease6;
        }
        if (idx == 7) {
            return UI_NumberHpIncrease7;
        }
        if (idx == 8) {
            return UI_NumberHpIncrease8;
        }
        if (idx == 9) {
            return UI_NumberHpIncrease9;
        }
        return UI_NumberHpIncrease0;
    }
}
}
