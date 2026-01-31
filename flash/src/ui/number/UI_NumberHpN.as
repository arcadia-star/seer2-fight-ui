package ui.number {
public class UI_NumberHpN {
    [Embed(source="/assets/UI.swf", symbol="UI_NumberHp0")]
    public static var UI_NumberHp0:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberHp1")]
    public static var UI_NumberHp1:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberHp2")]
    public static var UI_NumberHp2:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberHp3")]
    public static var UI_NumberHp3:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberHp4")]
    public static var UI_NumberHp4:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberHp5")]
    public static var UI_NumberHp5:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberHp6")]
    public static var UI_NumberHp6:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberHp7")]
    public static var UI_NumberHp7:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberHp8")]
    public static var UI_NumberHp8:Class;
    [Embed(source="/assets/UI.swf", symbol="UI_NumberHp9")]
    public static var UI_NumberHp9:Class;

    public static function find(idx:int):Class {
        if (idx == 0) {
            return UI_NumberHp0;
        }
        if (idx == 1) {
            return UI_NumberHp1;
        }
        if (idx == 2) {
            return UI_NumberHp2;
        }
        if (idx == 3) {
            return UI_NumberHp3;
        }
        if (idx == 4) {
            return UI_NumberHp4;
        }
        if (idx == 5) {
            return UI_NumberHp5;
        }
        if (idx == 6) {
            return UI_NumberHp6;
        }
        if (idx == 7) {
            return UI_NumberHp7;
        }
        if (idx == 8) {
            return UI_NumberHp8;
        }
        if (idx == 9) {
            return UI_NumberHp9;
        }
        return UI_NumberHp0;
    }
}
}
