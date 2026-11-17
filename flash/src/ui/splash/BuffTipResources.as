package ui.splash {
public class BuffTipResources {
    [Embed(source="/_assets/buff-tips.swf", symbol="UI_BuffTip_1")]
    private static var tip1:Class;
    [Embed(source="/_assets/buff-tips.swf", symbol="UI_BuffTip_2")]
    private static var tip2:Class;
    [Embed(source="/_assets/buff-tips.swf", symbol="UI_BuffTip_3")]
    private static var tip3:Class;
    [Embed(source="/_assets/buff-tips.swf", symbol="UI_BuffTip_5")]
    private static var tip5:Class;
    [Embed(source="/_assets/buff-tips.swf", symbol="UI_BuffTip_6")]
    private static var tip6:Class;
    [Embed(source="/_assets/buff-tips.swf", symbol="UI_BuffTip_7")]
    private static var tip7:Class;
    [Embed(source="/_assets/buff-tips.swf", symbol="UI_BuffTip_8")]
    private static var tip8:Class;
    [Embed(source="/_assets/buff-tips.swf", symbol="UI_BuffTip_9")]
    private static var tip9:Class;
    [Embed(source="/_assets/buff-tips.swf", symbol="UI_BuffTip_12")]
    private static var tip12:Class;
    private static const tips:Object = {1: tip1, 2: tip2, 3: tip3, 5: tip5, 6: tip6, 7: tip7, 8: tip8, 9: tip9, 12: tip12};

    public static function getTip(buffId:int):Class {
        return tips[buffId];
    }
}
}
