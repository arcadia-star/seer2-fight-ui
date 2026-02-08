package animation.common {

import flash.display.DisplayObject;
import flash.display.MovieClip;

import ui.IconFallback;

public class PetIconDisplay extends IconDisplay {
    public static const SIZE:int = 54;

    public function PetIconDisplay() {
        setSize(SIZE);
    }

    override protected function applyChange():void {
        try {
            //淘米的icon瞎写，这里尝试从里面解析出来，避免偏移
            if (maybeS2(_icon)) {
                _icon = new CroppedMovieClip(_icon as MovieClip, SIZE, SIZE);
            }
        } catch (e:*) {
            //ignore
        }
        super.applyChange();
    }

    private static function maybeS2(icon:DisplayObject):Boolean {
        if (icon is IconFallback) {
            return false;
        }
        if (!(icon is MovieClip)) {
            return false;
        }
        if (icon.width < SIZE) {
            return false;
        }
        var mc:MovieClip = icon as MovieClip;
        if (mc.numChildren > 1) {
            return true;
        }
        if (mc.numChildren == 1) {
            var child0:DisplayObject = mc.getChildAt(0);
            if (child0 is MovieClip && (child0 as MovieClip).numChildren > 1) {
                return true;
            }
        }
        return false;
    }
}
}
