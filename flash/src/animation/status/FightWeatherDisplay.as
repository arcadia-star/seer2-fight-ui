package animation.status {

import animation.common.IconDisplay;
import animation.common.TipsDisplay;

import flash.display.Sprite;

import ui.status.UI_WeatherIconBack;

import utils.an.DisplayObjectUtil;

internal class FightWeatherDisplay extends Sprite {


    private var _back:Sprite;

    private var _icon:IconDisplay;

    private var _tips:TipsDisplay;

    public function FightWeatherDisplay() {
        super();
        this._back = new UI_WeatherIconBack;
this._back.cacheAsBitmap = true;
        DisplayObjectUtil.disableSprite(this._back);
        addChild(this._back);
        this._icon = new IconDisplay();
        this._tips = new TipsDisplay(this._icon);
        _tips.x = 42;
        _tips.y = 4;
        _tips.visible = false;
        addChild(this._tips);
    }

    public function initData(param1:String, param2:String):void {
        if (param1) {
            _icon.initData(param1);
            _tips.visible = true;
            _tips.initData(param2);
        } else {
            _tips.visible = false;
        }
    }
}
}
