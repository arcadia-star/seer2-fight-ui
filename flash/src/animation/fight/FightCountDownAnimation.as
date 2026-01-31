package animation.fight {


import animation.event.Events;

import flash.display.MovieClip;
import flash.display.Sprite;

import ui.splash.UI_FightCountDown;

import utils.Utils;
import utils.an.DisplayObjectUtil;

public class FightCountDownAnimation extends Sprite {


    private var _animation:MovieClip;

    public function FightCountDownAnimation() {
        super();
        this.initialize();
    }

    public function initialize():void {
        DisplayObjectUtil.disableSprite(this);
        if (this._animation == null) {
            this._animation = new UI_FightCountDown;
        }
        this._animation.x = 591;
        this._animation.y = 291;
        this._animation.gotoAndStop(1);
        addChild(this._animation);
    }

    public function play():void {
        this._animation.play();
        Utils.onComplete(this._animation, onAnimationEnd);
    }

    public function dispose():void {
        if (this._animation != null) {
            this._animation.gotoAndStop(this._animation.totalFrames);
            DisplayObjectUtil.removeFromParent(this._animation);
            this._animation = null;
        }
    }

    private function onAnimationEnd():void {
        dispatchEvent(Events.animationEnd());
    }
}
}
