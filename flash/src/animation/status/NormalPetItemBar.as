package animation.status {
import animation.common.IconDisplay;
import animation.common.TipsDisplay;
import data.pet.PetExtData;
import flash.display.MovieClip;
import flash.display.Sprite;
import ui.Resource;
import utils.an.DisplayObjectUtil;

internal class NormalPetItemBar {
    private var _view:MovieClip;
    [Embed(source="/_assets/yucun/合体.swf", symbol="item")]
    public static var sex0:Class;
    [Embed(source="/_assets/yucun/雄性.swf", symbol="item")]
    public static var sex1:Class;
    [Embed(source="/_assets/yucun/雌性.swf", symbol="item")]
    public static var sex2:Class;
    [Embed(source="/_assets/yucun/特性.swf", symbol="item")]
    public static var feature0:Class;
    [Embed(source="/_assets/yucun/白纹章.swf", symbol="item")]
    public static var emblem1:Class;
    [Embed(source="/_assets/yucun/黑纹章.swf", symbol="item")]
    public static var emblem2:Class;
    [Embed(source="/_assets/yucun/羁绊.swf", symbol="item")]
    public static var fetter0:Class;
    [Embed(source="/_assets/yucun/变身.swf", symbol="item")]
    public static var morph0:Class;
    {
        Resource.clazz["UI_ext_sex0"] = sex0;
        Resource.clazz["UI_ext_sex1"] = sex1;
        Resource.clazz["UI_ext_sex2"] = sex2;
        Resource.clazz["UI_ext_feature0"] = feature0;
        Resource.clazz["UI_ext_emblem1"] = emblem1;
        Resource.clazz["UI_ext_emblem2"] = emblem2;
        Resource.clazz["UI_ext_fetter0"] = fetter0;
        Resource.clazz["UI_ext_morph0"] = morph0;
    }
    public function NormalPetItemBar(view:MovieClip) {
        _view=view;
    }
    public function initData(data:PetExtData):void {
        var items:Sprite=_view["items"];
        DisplayObjectUtil.removeAllChildren(items);
        if(!data)return;
        var entries:Array=[{icon:"UI_ext_sex"+(data.sex>2?0:data.sex),tips:"",feature:false}];
        if(data.featureTips)entries.push({icon:"UI_ext_feature0",tips:data.featureTips,feature:true});
        if(data.emblem1Tips)entries.push({icon:data.emblem1?"UI_ext_emblem1":"UI_ext_emblem2",tips:data.emblem1Tips,feature:false});
        if(data.emblem2Tips)entries.push({icon:data.emblem2?"UI_ext_emblem1":"UI_ext_emblem2",tips:data.emblem2Tips,feature:false});
        if(data.fetterTips)entries.push({icon:"UI_ext_fetter0",tips:data.fetterTips,feature:false});
        if(data.morphTips)entries.push({icon:"UI_ext_morph0",tips:data.morphTips,feature:false});
        var origin:Sprite=_view["origin"];
        var x:Number=origin.x,y:Number=origin.y;
        for each(var entry:Object in entries) {
            var icon:IconDisplay=new IconDisplay();
            icon.initData("internal://"+entry.icon);
            var content:Sprite=icon;
            if(entry.tips) {
                var tip:TipsDisplay=new TipsDisplay(icon);
                tip.initData(entry.tips);
                content=tip;
            }
            content.x=x;content.y=y;
            if(entry.feature) {
                content.x+=_view["featureOffset"].x-origin.x;
                content.y+=_view["featureOffset"].y-origin.y;
            }
            items.addChild(content);
            var step:Sprite=_view[entry.feature?"featureColumn":"column"];
            x+=step.x-origin.x;y+=step.y-origin.y;
        }
    }
}
}
