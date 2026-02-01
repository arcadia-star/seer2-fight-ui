package animation.ext {
import enums.FighterActionType;

import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.events.Event;
import flash.text.TextField;
import flash.utils.clearInterval;
import flash.utils.setInterval;

public class S1Pet extends MovieClip {
    public static const EXT:String = "ext-s1://";

    private var _origin:MovieClip;
    private var _text:TextField;

    public function S1Pet(origin:MovieClip) {
        this._origin = origin;
        addChild(_origin);
        _origin.x = 180;
        _origin.y = 250;
        _text = new TextField();
        addChild(_text);
        _text.y = _origin.y - 50;
        _text.textColor = 0xff0000;

        gotoAndStop(FighterActionType.IDLE);

        var interval:uint = setInterval(function ():void {
            if (!_origin.stage) {
                clearInterval(interval);
                return;
            }
            var ch0:MovieClip = _origin.getChildAt(0) as MovieClip;
            _text.text = _origin.currentFrame + "/" + _origin.totalFrames + "," +
                    (ch0 ? (ch0.currentFrame + "/" + ch0.totalFrames) : "");
        }, 100);
    }

    override public function get currentLabels():Array {
        return [
            {'name': FighterActionType.ATK_PHY},
            {'name': FighterActionType.ATK_SPE},
            {'name': FighterActionType.ATK_BUF},
            {'name': FighterActionType.UNDER_ATK},
            {'name': FighterActionType.IDLE}
        ]
    }

    override public function getChildAt(index:int):DisplayObject {
        return _origin.getChildAt(index);
    }

    override public function gotoAndStop(frame:Object, scene:String = null):void {
        //todo version
        var label:String;
        if (frame === FighterActionType.ATK_PHY) {
            label = "attack";
        } else if (frame === FighterActionType.ATK_SPE) {
            label = "sa";
        } else if (frame === FighterActionType.ATK_BUF) {
            label = "cp";
        } else if (frame === FighterActionType.UNDER_ATK) {
            label = "hited";
        } else {
            label = "attack";
        }
        _origin.gotoAndStop(label);

        function handleEnterFrame(event:Event):void {
            var child0:MovieClip = _origin.getChildAt(0) as MovieClip;
            if (child0) {
                _origin.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
                if (frame === FighterActionType.IDLE) {
                    child0.gotoAndStop(0);
                } else {
                    child0.gotoAndPlay(1);
                    child0.addEventListener(Event.ENTER_FRAME, handleEnterFrame1);

                    function handleEnterFrame1(event:Event):void {
                        if (child0.hit) {
                            child0.hit = false;
                            dispatchEvent(new Event("hit"));
                        }
                        if (child0.currentFrame == child0.totalFrames) {
                            child0.removeEventListener(Event.ENTER_FRAME, handleEnterFrame1);
                            child0.gotoAndStop(0);
                        }
                    }
                }
            }
        }

        _origin.addEventListener(Event.ENTER_FRAME, handleEnterFrame)
    }
}
}
