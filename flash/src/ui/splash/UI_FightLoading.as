package  ui.splash {
import flash.display.MovieClip;

[Embed(source="/_assets/assets.swf", symbol="UI_FightLoading")]
public dynamic class UI_FightLoading extends MovieClip {

    public var animation:UI_FightLoading_An;

    public var digital0:MovieClip;

    public var digital1:MovieClip;

    public var digital2:MovieClip;

    public var fighterInfoHolder:MovieClip;

    public function UI_FightLoading() {
        super();
        addFrameScript(0, this.frame1, 1, this.frame2);
    }

    internal function frame1():* {
        stop();
    }

    internal function frame2():* {
        stop();
    }
}
}

