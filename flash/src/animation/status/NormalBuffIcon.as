package animation.status {
import animation.common.IconDisplay;
import animation.common.TipsDisplay;

import data.pet.BuffData;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.text.TextField;

[Embed(source="/_assets/battle-ui.swf", symbol="UI_NormalBuffItem")]
public dynamic class NormalBuffIcon extends MovieClip {
    public var icon:MovieClip;
    public var count:TextField;
    private var _icon:IconDisplay = new IconDisplay();
    private var _tips:TipsDisplay;
    private var _showNumMin:int = 2;

    public function get view():Sprite {
        return _tips;
    }

    public function NormalBuffIcon() {
        icon.addChild(_icon);
        _icon.setSize(32);
        count.mouseEnabled = false;
        _tips = new TipsDisplay(this);
    }

    public function initData(buff:BuffData):void {
        _icon.initData(buff.icon);
        _tips.initData(buff.tips || "无");
        count.text = buff.count > 9999 ? "1w+" : String(buff.count);
        count.visible = buff.count >= _showNumMin;
    }

    public function setShowNumMin(value:int):void {
        _showNumMin = value;
    }
}
}
