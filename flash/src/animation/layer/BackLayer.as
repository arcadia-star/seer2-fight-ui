package animation.layer {

import enums.FightSide;

import flash.display.DisplayObject;
import flash.display.Sprite;

import utils.CacheUtils;
import utils.an.ArenaUtil;
import utils.an.DisplayObjectUtil;
import utils.an.vibration.DriftDirection;

public class BackLayer extends Sprite {
    private var _url:String;
    private var _sprite:DisplayObject;
    private var _front:Sprite;
    private var _ground:Sprite;

    public function initData(url:String):void {
        if (url === _url) {
            return
        }
        if (!url) {
            DisplayObjectUtil.removeFromParent(_sprite);
            _url = url;
            _sprite = null;
            return;
        }
        _url = url;
        CacheUtils.loadMapContent(url, function (obj:DisplayObject):void {
            if (_url === url) {
                DisplayObjectUtil.removeFromParent(_sprite);
                _sprite = obj;
                _front = _sprite["front_mc"];
                _ground = _sprite["ground_mc"];

                addChild(_sprite);
            }
        })
    }

    public function drift(side:int):void {
        if (side == FightSide.LEFT) {
            ArenaUtil.startDrift(DriftDirection.LEFT, _ground);
        } else {
            ArenaUtil.startDrift(DriftDirection.RIGHT, _ground);
        }

    }

    public function vibrate():void {
        ArenaUtil.startVibrate(_ground);
        ArenaUtil.startVibrate(_front);
    }

}
}
