package ui.splash {
import flash.display.MovieClip;

[Embed(source="/_assets/assets.swf", symbol="UI_FightKOAnimation")]
public dynamic class UI_FightKOAnimation extends MovieClip {

    public function UI_FightKOAnimation() {
        super();
        addFrameScript(54, this.frame55);
    }

    internal function frame55():* {
        stop();
    }
}
}

