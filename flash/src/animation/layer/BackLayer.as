package animation.layer {

import enums.FightSide;

import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;

import utils.CacheUtils;
import utils.an.ArenaUtil;
import utils.an.DisplayObjectUtil;
import utils.an.DisplayUtil;
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
            stopSprite(_sprite);
            DisplayObjectUtil.removeFromParent(_sprite);
            _url = url;
            _sprite = null;
            _front = null;
            _ground = null;
            return;
        }
        _url = url;
        CacheUtils.loadMapContent(url, function (obj:DisplayObject):void {
            if (_url === url) {
                stopSprite(_sprite);
                DisplayObjectUtil.removeFromParent(_sprite);
                _sprite = obj;
                try {
                    _front = _sprite["front_mc"];
                    _ground = _sprite["ground_mc"];
                } catch (e:*) {
                    //ignore
                }
                addChild(_sprite);
            }
        })
    }

    private function stopSprite(sprite:DisplayObject):void {
        if (sprite is MovieClip) {
            DisplayUtil.stopAllMovieClip(sprite as MovieClip);
        }
    }

    public function drift(side:int):void {
        if (!_ground) {
            return;
        }
        if (side == FightSide.LEFT) {
            ArenaUtil.startDrift(DriftDirection.LEFT, _ground);
        } else {
            ArenaUtil.startDrift(DriftDirection.RIGHT, _ground);
        }

    }

    public function vibrate():void {
        if (!_ground || !_front) {
            return;
        }
        ArenaUtil.startVibrate(_ground);
        ArenaUtil.startVibrate(_front);
    }

}
}
