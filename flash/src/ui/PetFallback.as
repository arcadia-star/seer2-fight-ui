package ui {
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.events.Event;
import flash.text.TextField;
import flash.utils.clearInterval;
import flash.utils.setInterval;

public class PetFallback extends MovieClip {
    [Embed(source="/assets/pet0.swf", symbol="pet")]
    public static var Pet0:Class;

    private var _origin:MovieClip;

    public function PetFallback() {
        _origin = new Pet0;
        addChild(_origin);

        _origin.addEventListener(Event.ENTER_FRAME, function (event:Event):void {
            var ch0:MovieClip = _origin.getChildAt(0) as MovieClip;
            if (ch0) {
                if (_origin.currentFrame === 6 && ch0.currentFrame === 39) {
                    dispatchEvent(new Event("hit", true));
                } else if (_origin.currentFrame === 14 && ch0.currentFrame === 22) {
                    dispatchEvent(new Event("hit", true));
                } else if (_origin.currentFrame === 22 && ch0.currentFrame === 58) {
                    dispatchEvent(new Event("hit", true));
                } else if (_origin.currentFrame === 63 && ch0.currentFrame === 123) {
                    dispatchEvent(new Event("hit", true));
                }
            }
        });

        addChild(showPetFrames(_origin));
    }

    override public function get currentLabels():Array {
        return _origin.currentLabels;
    }

    override public function getChildAt(index:int):DisplayObject {
        return _origin.getChildAt(index);
    }

    override public function gotoAndStop(frame:Object, scene:String = null):void {
        _origin.gotoAndStop(frame, scene);
    }

    public static function showPetFrames(origin:MovieClip):TextField {
        var _text:TextField = new TextField();
        _text.y = 200;
        _text.textColor = 0xff0000;
        var interval:uint = setInterval(function ():void {
            if (!origin.stage) {
                clearInterval(interval);
                return;
            }
            var ch0:MovieClip = origin.getChildAt(0) as MovieClip;
            _text.text = origin.currentFrame + "/" + origin.totalFrames + "," +
                    (ch0 ? (ch0.currentFrame + "/" + ch0.totalFrames) : "");
        }, 100);
        return _text;
    }
}
}
