package ui.splash {
import flash.display.MovieClip;
import flash.events.Event;

[Embed(source="/_assets/assets.swf", symbol="UI_FightHpRecover")]
public dynamic class UI_FightHpRecover extends MovieClip {

    public function UI_FightHpRecover() {
        super();
        addFrameScript(59, this.frame60);
    }

    internal function frame60():* {
        stop();
        dispatchEvent(new Event("end", true));
    }
}
}

