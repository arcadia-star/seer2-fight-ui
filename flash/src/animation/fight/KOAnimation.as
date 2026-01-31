package animation.fight {


import animation.event.Events;

import flash.display.MovieClip;
import flash.display.Sprite;

import ui.splash.UI_FightKOAnimation;

import utils.Utils;
import utils.an.DisplayObjectUtil;

public class KOAnimation extends Sprite {

    private var _animation:MovieClip;

    public function KOAnimation() {
        super();
        this.initialize();
    }

    public function initialize():void {
        DisplayObjectUtil.disableSprite(this);
    }

    public function play():void {
        this._animation = new UI_FightKOAnimation;
        this._animation.x = 32;
        this._animation.y = 181;
        addChild(this._animation);
        Utils.onComplete(this._animation, onAnimationEnd)
    }

    private function onAnimationEnd():void {
        dispatchEvent(Events.animationEnd());
    }

    public function dispose():void {
        DisplayObjectUtil.removeFromParent(this._animation);
        this._animation = null;
    }
}
}
