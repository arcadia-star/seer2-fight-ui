package ui {
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.events.Event;
import flash.text.TextField;

public class PetFallback extends MovieClip {
    [Embed(source="/_assets/assets.swf", symbol="UI_Pet0")]
    public static var Pet0:Class;

    private var _origin:MovieClip;

    public function PetFallback() {
        _origin = new Pet0;
        addChild(_origin);

        addHitEvent(_origin);

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

    public static function addHitEvent(origin:MovieClip):void {
        origin.addEventListener(Event.ENTER_FRAME, function (event:Event):void {
            var origin:MovieClip = event.target as MovieClip;
            if (!origin.numChildren) {
                return;
            }
            var child0:MovieClip = origin.getChildAt(0) as MovieClip;
            var hit:Boolean = false;
            if (child0) {
                if (origin.currentFrame === 6 && child0.currentFrame === 39) {
                    hit = true;
                } else if (origin.currentFrame === 14 && child0.currentFrame === 22) {
                    hit = true;
                } else if (origin.currentFrame === 22 && child0.currentFrame === 58) {
                    hit = true;
                } else if (origin.currentFrame === 63 && child0.currentFrame === 123) {
                    hit = true;
                }
            }
            if (hit) {
                origin.dispatchEvent(new Event("hit", true));
            }
        }, false, 0, true);
    }

    public static function showPetFrames(origin:MovieClip):TextField {
        var _text:TextField = new TextField();
        _text.y = 200;
        _text.textColor = 0xff0000;
        origin.addEventListener(Event.ENTER_FRAME, function (event:Event):void {
            var origin:MovieClip = event.target as MovieClip;
            var child0:MovieClip = origin.numChildren ? origin.getChildAt(0) as MovieClip : null;
            _text.text = origin.currentFrame + "/" + origin.totalFrames + "," +
                    (child0 ? (child0.currentFrame + "/" + child0.totalFrames) : "");
        }, false, 0, true);
        return _text;
    }
}
}
