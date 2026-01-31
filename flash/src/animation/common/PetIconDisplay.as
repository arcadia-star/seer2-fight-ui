package animation.common {

import flash.display.MovieClip;

public class PetIconDisplay extends IconDisplay {

    override protected function applyChange():void {
        try {
            //淘米的icon瞎写，这里尝试从里面解析出来，避免偏移
            if (_icon is MovieClip) {
                var mc:MovieClip = _icon as MovieClip;
                if (mc.totalFrames === 1 && mc.width > 54) {
                    _icon = new CroppedMovieClip(mc, 54, 54);
                }
            }
        } catch (e:*) {
        }
        super.applyChange();
    }
}
}
