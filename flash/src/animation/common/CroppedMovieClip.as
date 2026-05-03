package animation.common {
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.geom.Rectangle;

public class CroppedMovieClip extends Sprite {
    private var _content:MovieClip;
    private var _cropRect:Rectangle;

    public function CroppedMovieClip(content:MovieClip, initialWidth:Number, initialHeight:Number) {
        _content = content;
        addChild(_content);

        // 初始化裁切矩形
        _cropRect = new Rectangle(0, 0, initialWidth, initialHeight);
        _content.scrollRect = _cropRect;
    }

    // 重写width的getter，返回裁切区域的宽度
    override public function get width():Number {
        return _cropRect.width;
    }

    // 重写width的setter，改变裁切区域的宽度
    override public function set width(value:Number):void {
        if (_cropRect.width !== value) {
            _cropRect.width = value;
            _content.scrollRect = _cropRect;
        }
    }

    // 重写height的getter，返回裁切区域的高度
    override public function get height():Number {
        return _cropRect.height;
    }

    // 重写height的setter，改变裁切区域的高度
    override public function set height(value:Number):void {
        if (_cropRect.height !== value) {
            _cropRect.height = value;
            _content.scrollRect = _cropRect;
        }
    }

    // 如果需要，也可以提供改变裁切位置的方法
    public function setCropPosition(x:Number, y:Number):void {
        if (_cropRect.x !== x || _cropRect.y !== y) {
            _cropRect.x = x;
            _cropRect.y = y;
            _content.scrollRect = _cropRect;
        }
    }

    public function setCropSize(width:Number, height:Number):void {
        if (_cropRect.width !== width || _cropRect.height !== height) {
            _cropRect.width = width;
            _cropRect.height = height;
            _content.scrollRect = _cropRect;
        }
    }

    // 获取内部MovieClip的引用
    public function get content():MovieClip {
        return _content;
    }
}
}
