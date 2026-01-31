package animation.fight {

import animation.event.Events;

import flash.display.MovieClip;
import flash.display.Sprite;

import ui.splash.UI_BaoJiSkillHit;

import utils.Utils;
import utils.an.DisplayObjectUtil;

public class BaoJiHitAnimation extends Sprite {

    private var _animationBaojiHit:MovieClip;

    public function BaoJiHitAnimation() {
        super();
        this.initialize();
    }

    public function initialize():void {
        this.mouseChildren = false;
        this.mouseEnabled = false;
    }

    public function play():void {
        if (this._animationBaojiHit == null) {
            this._animationBaojiHit = new UI_BaoJiSkillHit;
        }
        addChild(this._animationBaojiHit);
        Utils.onComplete(this._animationBaojiHit, onAnimationEnd)
    }

    private function onAnimationEnd():void {
        DisplayObjectUtil.removeFromParent(this._animationBaojiHit);
        dispatchEvent(Events.animationEnd());
    }

    public function dispose():void {
    }
}
}
