package ui.number {
public class UI_NumberPetLevelN {
    [Embed(source="/_assets/assets.swf", symbol="UI_NumberPetLevel0")]
    public static var UI_NumberPetLevel0:Class;
    [Embed(source="/_assets/assets.swf", symbol="UI_NumberPetLevel1")]
    public static var UI_NumberPetLevel1:Class;
    [Embed(source="/_assets/assets.swf", symbol="UI_NumberPetLevel2")]
    public static var UI_NumberPetLevel2:Class;
    [Embed(source="/_assets/assets.swf", symbol="UI_NumberPetLevel3")]
    public static var UI_NumberPetLevel3:Class;
    [Embed(source="/_assets/assets.swf", symbol="UI_NumberPetLevel4")]
    public static var UI_NumberPetLevel4:Class;
    [Embed(source="/_assets/assets.swf", symbol="UI_NumberPetLevel5")]
    public static var UI_NumberPetLevel5:Class;
    [Embed(source="/_assets/assets.swf", symbol="UI_NumberPetLevel6")]
    public static var UI_NumberPetLevel6:Class;
    [Embed(source="/_assets/assets.swf", symbol="UI_NumberPetLevel7")]
    public static var UI_NumberPetLevel7:Class;
    [Embed(source="/_assets/assets.swf", symbol="UI_NumberPetLevel8")]
    public static var UI_NumberPetLevel8:Class;
    [Embed(source="/_assets/assets.swf", symbol="UI_NumberPetLevel9")]
    public static var UI_NumberPetLevel9:Class;

    public static function find(idx:int):Class {
        if (idx == 0) {
            return UI_NumberPetLevel0;
        }
        if (idx == 1) {
            return UI_NumberPetLevel1;
        }
        if (idx == 2) {
            return UI_NumberPetLevel2;
        }
        if (idx == 3) {
            return UI_NumberPetLevel3;
        }
        if (idx == 4) {
            return UI_NumberPetLevel4;
        }
        if (idx == 5) {
            return UI_NumberPetLevel5;
        }
        if (idx == 6) {
            return UI_NumberPetLevel6;
        }
        if (idx == 7) {
            return UI_NumberPetLevel7;
        }
        if (idx == 8) {
            return UI_NumberPetLevel8;
        }
        if (idx == 9) {
            return UI_NumberPetLevel9;
        }
        return UI_NumberPetLevel0;
    }
}
}
