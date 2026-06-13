package animation.ext {
import enums.FighterActionType;

import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.utils.clearInterval;
import flash.utils.setInterval;

import utils.Utils;

public class TimeDrivenPet extends MovieClip {
    private var _origin:MovieClip;
    private var _text:TextField;

    public function TimeDrivenPet(origin:MovieClip) {
        this._origin = origin;
        addChild(_origin);
        _text = new TextField();
        _text.defaultTextFormat = new TextFormat("_sans", 25);
        _text.textColor = 0x00ff00;
        _text.text = "sssss";
        addChild(_text);
        _text.x = 0;
        _text.y = 100;
    }

    override public function get currentLabels():Array {
        return _origin.currentLabels;
    }

    override public function getChildAt(index:int):DisplayObject {
        return _origin.getChildAt(index);
    }

    private var version:int;

    override public function gotoAndStop(frame:Object, scene:String = null):void {

        //return _origin.gotoAndStop(frame);

        version++;
        var versionSnapshot:int = version;
        Utils.gotoAndStop(_origin, frame, function ():void {
            // 现在可以安全地访问数据了
            var _child0:MovieClip = _origin.getChildAt(0) as MovieClip;
            _child0.stop();
            var interval:uint = setInterval(function ():void {
                if (versionSnapshot !== version) {
                    clearInterval(interval);
                    return;
                }
                _text.text = "" + _child0.currentFrame + "/" + _child0.totalFrames + "";
                var nextFrame:int = _child0.currentFrame + 1;
                if (nextFrame > _child0.totalFrames) {
                    if (frame !== FighterActionType.IDLE) {
                        nextFrame = nextFrame - 1;
                    } else {
                        nextFrame = 1;
                    }
                }
                _child0.gotoAndStop(nextFrame);
            }, 1);
        });
    }
}
}

