package ui.splash {
import flash.display.MovieClip;
import flash.events.Event;

[Embed(source="/assets/UI_Arena.swf", symbol="UI_FightCatchSuccess")]
public dynamic class UI_FightCatchSuccess extends MovieClip {
    public function UI_FightCatchSuccess() {
        super();
        addFrameScript(88, this.frame89, 160, this.frame161);
    }

    internal function frame89():* {
        dispatchEvent(new Event("success"));
    }

    internal function frame161():* {
        stop();
        dispatchEvent(new Event("end"));
    }
}
}

