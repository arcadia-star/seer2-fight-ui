package ui.number {
public class UI_NumberItemN {
    [Embed(source="/assets/UI.swf", symbol="UI_NumberItem0")]
    public static var UI_NumberItem0:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberItem1")]
    public static var UI_NumberItem1:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberItem2")]
    public static var UI_NumberItem2:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberItem3")]
    public static var UI_NumberItem3:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberItem4")]
    public static var UI_NumberItem4:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberItem5")]
    public static var UI_NumberItem5:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberItem6")]
    public static var UI_NumberItem6:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberItem7")]
    public static var UI_NumberItem7:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberItem8")]
    public static var UI_NumberItem8:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberItem9")]
    public static var UI_NumberItem9:Class;

    public static function find(idx:int):Class {
        if (idx == 0) {
            return UI_NumberItem0;
        }
        if (idx == 1) {
            return UI_NumberItem1;
        }
        if (idx == 2) {
            return UI_NumberItem2;
        }
        if (idx == 3) {
            return UI_NumberItem3;
        }
        if (idx == 4) {
            return UI_NumberItem4;
        }
        if (idx == 5) {
            return UI_NumberItem5;
        }
        if (idx == 6) {
            return UI_NumberItem6;
        }
        if (idx == 7) {
            return UI_NumberItem7;
        }
        if (idx == 8) {
            return UI_NumberItem8;
        }
        if (idx == 9) {
            return UI_NumberItem9;
        }
        return UI_NumberItem0;
    }
}
}
