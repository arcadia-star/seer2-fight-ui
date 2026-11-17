package animation.status {
import animation.common.IconDisplay;
import animation.common.TipsDisplay;
import data.pet.BuffData;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.text.TextField;
import ui.status.UI_NormalBuffItem;

internal class NormalBuffIcon {
    private var _clip:MovieClip=new UI_NormalBuffItem();
    private var _icon:IconDisplay=new IconDisplay();
    private var _tips:TipsDisplay;
    private var _count:TextField;
    private var _showNumMin:int=2;
    public function get view():Sprite {return _tips;}
    public function NormalBuffIcon() {
        _clip["icon"].addChild(_icon);
        _icon.setSize(32);
        _count=_clip["count"];
        _count.mouseEnabled=false;
        _tips=new TipsDisplay(_clip);
    }
    public function initData(buff:BuffData):void {
        _icon.initData(buff.icon);
        _tips.initData(buff.tips || "无");
        _count.text=buff.count>9999?"1w+":String(buff.count);
        _count.visible=buff.count>=_showNumMin;
    }
    public function setShowNumMin(value:int):void {_showNumMin=value;}
}
}
