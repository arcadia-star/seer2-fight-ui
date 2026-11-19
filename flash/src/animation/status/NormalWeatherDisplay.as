package animation.status {
import animation.common.IconDisplay;
import animation.common.TipsDisplay;

import flash.display.MovieClip;

import utils.an.DisplayObjectUtil;

[Embed(source="/_assets/battle-ui.swf", symbol="WeatherDisplaySkin")]
public dynamic class NormalWeatherDisplay extends MovieClip {
    public var back:MovieClip;
    public var icon:MovieClip;
    private var _icon:IconDisplay = new IconDisplay();
    private var _tips:TipsDisplay;

    public function NormalWeatherDisplay() {
        DisplayObjectUtil.disableSprite(back);
        _tips = new TipsDisplay(_icon);
        icon.addChild(_tips);
    }

    public function initData(param1:String, param2:String):void {
        if (param1) {
            this._icon.initData(param1);
            this._tips.visible = true;
            this._tips.initData(param2);
            this.back.visible = true;
        } else {
            _tips.visible = false;
            back.visible = false;
        }
    }
}
}
