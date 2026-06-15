package animation.ext {
import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.events.Event;
import flash.geom.Point;

import utils.FrameBitmapCache;

/**
 * 新的动画播放器：包裹外层容器 MovieClip（S1Pet / ImgPet / 原始 MC）。
 * 每帧取子元件 MovieClip（真正的动画），若该子元件当前帧已在 FrameBitmapCache 中被预渲染，
 * 就隐藏原动画，用渲染好的位图替代；否则照常显示。
 *
 * 行为对调用方透明：暴露 currentLabels / getChildAt / gotoAndStop 等与现有 wrapper 兼容的接口。
 * 子元件查找逻辑参考 PetLayer.loadMoveFrame 中 pet.getChildAt(0) 的用法。
 */
public class BitmapCachedPet extends MovieClip {

    private var _origin:MovieClip;
    private var _url:String;
    private var _bitmap:Bitmap;
    private var _lastInnerFrame:int = -1;
    private var _lastChildFrame:int = -1;

    public function BitmapCachedPet(origin:MovieClip, url:String) {
        this._origin = origin;
        this._url = url;
        addChild(_origin);

        _bitmap = new Bitmap();
        _bitmap.visible = false;
        addChild(_bitmap);

        addEventListener(Event.ENTER_FRAME, handleEnterFrame);
    }

    override public function get currentLabels():Array {
        return _origin.currentLabels;
    }

    override public function get currentFrame():int {
        return _origin.currentFrame;
    }

    override public function get totalFrames():int {
        return _origin.totalFrames;
    }

    override public function getChildAt(index:int):DisplayObject {
        return _origin.getChildAt(index);
    }

    override public function gotoAndStop(frame:Object, scene:String = null):void {
        _origin.gotoAndStop(frame, scene);
        _lastInnerFrame = -1;
        _lastChildFrame = -1;
        updateDisplay();
    }

    override public function gotoAndPlay(frame:Object, scene:String = null):void {
        _origin.gotoAndPlay(frame, scene);
        _lastInnerFrame = -1;
        _lastChildFrame = -1;
        updateDisplay();
    }

    private function handleEnterFrame(event:Event):void {
        updateDisplay();
    }

    private function updateDisplay():void {
        // 参考 PetLayer.loadMoveFrame: pet.getChildAt(0) 取得子元件动画
        if (_origin.numChildren === 0) {
            _origin.visible = true;
            _bitmap.visible = false;
            _lastInnerFrame = -1;
            _lastChildFrame = -1;
            return;
        }
        var childMc:MovieClip = _origin.getChildAt(0) as MovieClip;
        if (!childMc) {
            _origin.visible = true;
            _bitmap.visible = false;
            _lastInnerFrame = -1;
            _lastChildFrame = -1;
            return;
        }

        // 子元件的 parent 就是有标签的内层 MC（S1Pet/ImgPet 的 _origin，或原始 MC 自身）
        var innerParent:MovieClip = childMc.parent as MovieClip;
        var innerFrame:int = innerParent ? innerParent.currentFrame : 0;
        var childFrame:int = childMc.currentFrame;

        if (innerFrame === _lastInnerFrame && childFrame === _lastChildFrame) {
            return;
        }
        _lastInnerFrame = innerFrame;
        _lastChildFrame = childFrame;

        var cached:Object = FrameBitmapCache.getCachedChildFrame(_url, innerFrame, childFrame);
        if (cached) {
            _origin.visible = false;

            // bitmapData.draw 不应用 scaleX/scaleY，需从 childMc 自身开始累缩放
            var accScaleX:Number = 1.0;
            var accScaleY:Number = 1.0;
            var p:DisplayObject = childMc;
            while (p && p != this) {
                accScaleX *= p.scaleX;
                accScaleY *= p.scaleY;
                p = p.parent;
            }

            // offsetX/offsetY 是 childMc 本地坐标，需转到 BitmapCachedPet 坐标系
            var pt:Point = new Point(cached.offsetX, cached.offsetY);
            pt = childMc.localToGlobal(pt);
            pt = this.globalToLocal(pt);
            _bitmap.bitmapData = cached.bitmapData;
            _bitmap.x = pt.x;
            _bitmap.y = pt.y;
            _bitmap.scaleX = accScaleX;
            _bitmap.scaleY = accScaleY;
            _bitmap.visible = true;
        } else {
            _origin.visible = true;
            _bitmap.visible = false;
        }
    }
}
}