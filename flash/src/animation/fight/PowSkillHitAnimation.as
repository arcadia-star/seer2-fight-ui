package animation.fight {


import animation.event.Events;

import flash.display.MovieClip;
import flash.display.Sprite;

import ui.splash.UI_PowerSkillHit;

import utils.Utils;
import utils.an.DisplayUtil;

public class PowSkillHitAnimation extends Sprite {

    private var _animationSkillHit:MovieClip;

    public function PowSkillHitAnimation() {
        super();
        this.initialize();
    }

    public function initialize():void {
        this.mouseChildren = false;
        this.mouseEnabled = false;
    }

    public function play():void {
        if (this._animationSkillHit == null) {
            this._animationSkillHit = new UI_PowerSkillHit;
        }
        addChild(this._animationSkillHit);
        Utils.onComplete(this._animationSkillHit, onAnimationEnd)

    }

    private function onAnimationEnd():void {
        dispatchEvent(Events.animationEnd());
    }

    public function dispose():void {
        if (this._animationSkillHit != null) {
            DisplayUtil.removeForParent(this._animationSkillHit);
            this._animationSkillHit = null;
        }
    }
}
}
