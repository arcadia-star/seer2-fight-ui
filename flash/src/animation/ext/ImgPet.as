package animation.ext {
import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.MovieClip;

import ui.PetFallback;

import utils.an.DisplayObjectUtil;

public class ImgPet extends MovieClip {
    [Embed(source="/_assets/assets.swf", symbol="UI_ImgPet0")]
    public static var Pet0:Class;

    public var _img:Bitmap;
    public var _origin:MovieClip;

    public function ImgPet(img:Bitmap) {
        _img = img;
        DisplayObjectUtil.setSize(_img, 240, 240)
        _img.x = 70;
        _img.y = 110;
        addChild(_img);

        _origin = new Pet0;
        addChild(_origin);

        PetFallback.addHitEvent(_origin);
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
}
}
