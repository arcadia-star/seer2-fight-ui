package ui.splash {
import flash.display.MovieClip;
import flash.events.Event;

[Embed(source="/_assets/assets.swf", symbol="UI_FightLoading_An")]
public dynamic class UI_FightLoading_An extends MovieClip {

    public function UI_FightLoading_An() {
        super();
        addFrameScript(39, this.frame40, 79, this.frame80, 80, this.frame81);
    }

    internal function frame40():* {
        dispatchEvent(new Event("display", true));
        stop();
    }

    internal function frame80():* {
        dispatchEvent(new Event("end", true));
    }

    internal function frame81():* {
        stop();
    }
}
}
