package ui.splash {
import flash.display.MovieClip;
import flash.events.Event;

[Embed(source="/_assets/assets.swf", symbol="UI_FightCatchHint")]
public dynamic class UI_FightCatchHint extends MovieClip {
    public function UI_FightCatchHint() {
        super();
        addFrameScript(54, this.frame55);
    }

    internal function frame55():* {
        dispatchEvent(new Event("end"));
        stop();
    }
}
}

