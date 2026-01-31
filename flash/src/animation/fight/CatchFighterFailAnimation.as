package animation.fight {

import animation.event.Events;

import flash.display.MovieClip;
import flash.display.Sprite;

import ui.splash.UI_FightCatchFailed;

import utils.Utils;
import utils.an.DisplayObjectUtil;

public class CatchFighterFailAnimation extends Sprite {

    private var _failedAnimation:MovieClip;

    public function CatchFighterFailAnimation() {
        super();
        this.initialize();
    }

    public function initialize():void {
        this.mouseChildren = false;
        this.mouseEnabled = false;
    }

    public function play():void {
        if (this._failedAnimation == null) {
            this._failedAnimation = new UI_FightCatchFailed;
            this._failedAnimation.scaleX = -1;
            this._failedAnimation.x = 1200;
        }
        addChild(this._failedAnimation);
        Utils.onComplete(this._failedAnimation, onAnimationEnd);
    }

    private function onAnimationEnd():void {
        DisplayObjectUtil.removeFromParent(this._failedAnimation);
        dispatchEvent(Events.animationEnd());
    }

    public function dispose():void {
        if (this._failedAnimation != null) {
            this._failedAnimation.scaleX = 1;
            DisplayObjectUtil.removeFromParent(this._failedAnimation);
            this._failedAnimation = null;
        }
    }
}
}
