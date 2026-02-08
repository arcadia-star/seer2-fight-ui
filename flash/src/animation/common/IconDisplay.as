package animation.common {

import flash.display.DisplayObject;
import flash.display.Sprite;

import utils.CacheUtils;
import utils.an.DisplayObjectUtil;

public class IconDisplay extends Sprite {
    protected var _url:String;
    protected var _icon:DisplayObject;

    protected var _maxWidth:Number;
    protected var _maxHeight:Number;

    public function IconDisplay() {
        mouseChildren = false;
    }

    public function initData(url:String):void {
        if (url === _url) {
            return
        }
        if (!url) {
            DisplayObjectUtil.removeFromParent(_icon);
            _url = url;
            _icon = null;
            return;
        }
        _url = url;
        CacheUtils.loadItem(url, function (obj:DisplayObject):void {
            if (_url === url) {
                DisplayObjectUtil.removeFromParent(_icon);
                _icon = obj;
                if (!isNaN(_maxWidth)) {
                    applyChange();
                }
                addChild(_icon);
            }
        })
    }

    public function setSize(param1:Number):void {
        setBoundary(param1, param1);
    }

    public function setBoundary(param1:Number, param2:Number):void {
        this._maxWidth = param1;
        this._maxHeight = param2;
    }

    protected function applyChange():void {
        DisplayObjectUtil.setSize(_icon, _maxWidth, _maxHeight);
    }
}
}
