package ui {
public class UI_FightSplash_N {
    [Embed(source="/_assets/assets.swf", symbol="UI_FightSplash0")]
    public static var UI_FightSplash0:Class;
    [Embed(source="/_assets/assets.swf", symbol="UI_FightSplash1")]
    public static var UI_FightSplash1:Class;
    [Embed(source="/_assets/assets.swf", symbol="UI_FightSplash2")]
    public static var UI_FightSplash2:Class;
    [Embed(source="/_assets/assets.swf", symbol="UI_FightSplash3")]
    public static var UI_FightSplash3:Class;
    [Embed(source="/_assets/assets.swf", symbol="UI_FightSplash4")]
    public static var UI_FightSplash4:Class;
    [Embed(source="/_assets/assets.swf", symbol="UI_FightSplash5")]
    public static var UI_FightSplash5:Class;
    [Embed(source="/_assets/assets.swf", symbol="UI_FightSplash6")]
    public static var UI_FightSplash6:Class;
    [Embed(source="/_assets/assets.swf", symbol="UI_FightSplash7")]
    public static var UI_FightSplash7:Class;
    [Embed(source="/_assets/assets.swf", symbol="UI_FightSplash8")]
    public static var UI_FightSplash8:Class;
    [Embed(source="/_assets/assets.swf", symbol="UI_FightSplash9")]
    public static var UI_FightSplash9:Class;

    public static function find(idx:int):Class {
        if (idx == 0) {
            return UI_FightSplash0;
        }
        if (idx == 1) {
            return UI_FightSplash1;
        }
        if (idx == 2) {
            return UI_FightSplash2;
        }
        if (idx == 3) {
            return UI_FightSplash3;
        }
        if (idx == 4) {
            return UI_FightSplash4;
        }
        if (idx == 5) {
            return UI_FightSplash5;
        }
        if (idx == 6) {
            return UI_FightSplash6;
        }
        if (idx == 7) {
            return UI_FightSplash7;
        }
        if (idx == 8) {
            return UI_FightSplash8;
        }
        if (idx == 9) {
            return UI_FightSplash9;
        }
        return UI_FightSplash0;
    }
}
}
