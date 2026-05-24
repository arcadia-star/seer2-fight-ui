package animation.common {

import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;

import ui.IconFallback;

import utils.CacheUtils;
import utils.an.DisplayObjectUtil;

public class IconDisplay extends Sprite {
    protected var _url:String;
    protected var _icon:DisplayObject;

    protected var _maxWidth:Number;
    protected var _maxHeight:Number;
    protected var _scaleX:Number;
    protected var _scaleY:Number;
    private var _useScale:Boolean = false;

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
            if (_url === url && parent) {
                DisplayObjectUtil.removeFromParent(_icon);
                _icon = mayWrapIcon(url, obj);
                if(_useScale) {
                    if (!isNaN(_scaleX)) {
                        _icon.scaleX = _scaleX;
                        _icon.scaleY = _scaleY;
                    }
                }
                else {
                    if (!isNaN(_maxWidth)) {
                        DisplayObjectUtil.setSize(_icon, _maxWidth, _maxHeight);
                    }
                }
                addChild(_icon);
            }
        })
    }

    public function setSize(param1:Number):void {
        setBoundary(param1, param1);
    }

    public function setBoundary(param1:Number, param2:Number):void {
        this._useScale = false;
        this._maxWidth = param1;
        this._maxHeight = param2;
        if(_icon) {
            DisplayObjectUtil.setSize(_icon, _maxWidth, _maxHeight);
        }
    }

    public function setScale(scaleX:Number, scaleY:Number):void {
        /*setBoundary通过绝对数值设置缩放,有时我们希望通过相对数值来更灵活地缩放;
        两个参数是宽与高的缩放倍数;
        特别地,某参数为0时则维持原判(保持原来的缩放倍率);
        非常不希望你设置缩放0倍,不想让他显示的话建议直接设置visible*/
        this._useScale = true;
        if(scaleX){this._scaleX = scaleX;}
        if(scaleX){this._scaleY = scaleY;}
        if(_icon) {
            _icon.scaleX = scaleX;
            _icon.scaleY = scaleY;
        }
    }

    private static function mayWrapIcon(url:String, obj:DisplayObject):DisplayObject {
        if (obj is IconFallback) {
            return obj;
        }

        if (url.indexOf("res/pet/icon/") !== -1) {
            return new CroppedMovieClip(obj as MovieClip, 54, 54);
        }

        if (url.indexOf("res/skill/sideEffect/") !== -1) {
            return new CroppedMovieClip(obj as MovieClip, 30, 30);
        }

        return obj;
    }
}
}
