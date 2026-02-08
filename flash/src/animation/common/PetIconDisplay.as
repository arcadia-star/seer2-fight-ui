package animation.common {

import flash.display.MovieClip;

public class PetIconDisplay extends IconDisplay {
    public static const SIZE:int = 54;

    public function PetIconDisplay() {
        setSize(SIZE);
    }

    override protected function applyChange():void {
        try {
            //淘米的icon瞎写，这里尝试从里面解析出来，避免偏移
            if (_icon is MovieClip) {
                var mc:MovieClip = _icon as MovieClip;
                if (mc.totalFrames === 1 && mc.numChildren > 1 && mc.width > SIZE) {
                    _icon = new CroppedMovieClip(mc, SIZE, SIZE);
                }
            }
        } catch (e:*) {
            //ignore
        }
        super.applyChange();
    }
}
}
