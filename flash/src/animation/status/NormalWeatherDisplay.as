package animation.status {
import animation.common.IconDisplay;
import animation.common.TipsDisplay;
import flash.display.MovieClip;
import utils.an.DisplayObjectUtil;

internal class NormalWeatherDisplay {
    private var _view:MovieClip;
    private var _back:MovieClip;
    private var _icon:IconDisplay=new IconDisplay();
    private var _tips:TipsDisplay;
    public function NormalWeatherDisplay(view:MovieClip) {
        _view=view;_back=view["back"];
        DisplayObjectUtil.disableSprite(_back);
        _tips=new TipsDisplay(_icon);view["icon"].addChild(_tips);
    }
    public function initData(param1:String, param2:String):void {
        if (param1) {
            this._icon.initData(param1);
            this._tips.visible = true;
            this._tips.initData(param2);
            this._back.visible = true;
        } else {
            _tips.visible = false;
            _back.visible = false;
        }
    }
}
}
