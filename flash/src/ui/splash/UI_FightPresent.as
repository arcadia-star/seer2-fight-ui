package ui.splash {
import flash.display.MovieClip;
import flash.events.Event;

[Embed(source="/assets/UI_Arena.swf", symbol="UI_FightPresent")]
public dynamic class UI_FightPresent extends MovieClip {
    public function UI_FightPresent() {
        super();
        addFrameScript(44, this.frame45, 77, this.frame78);
    }

    internal function frame45():* {
        dispatchEvent(new Event("present", true));
    }

    internal function frame78():* {
        dispatchEvent(new Event("end", true));
        stop();
    }
}
}

