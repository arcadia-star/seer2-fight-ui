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
        DisplayObjectUtil.disableSprite(this._back);
        addChild(this._back);
        this._back.visible = false;
        this._icon = new IconDisplay();
        this._tips = new TipsDisplay(this._icon);
        this._tips.x = 45;
        this._tips.y = 5;
        this._tips.visible = false;
        addChild(this._tips);
    }

    public function initData(param1:String, param2:String):void {
        if (param1) {
            this._icon.initData(param1);
            this._tips.visible = true;
            this._tips.initData(param2);
            this._back.visible = true;
        } else {
            _tips.visible = false;
        }
    }
}
}
