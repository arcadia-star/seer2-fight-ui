package  ui {
import flash.display.MovieClip;

[Embed(source="/assets/UI_Arena.swf", symbol="UI_FightLoading")]
public dynamic class UI_FightLoading extends MovieClip {
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

