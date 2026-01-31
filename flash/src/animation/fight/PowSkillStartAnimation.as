package animation.fight {


import animation.event.Events;

import enums.FightSide;

import flash.display.MovieClip;
import flash.display.Sprite;

import ui.splash.UI_PowerSkillStart;

import utils.Utils;
import utils.an.DisplayUtil;

public class PowSkillStartAnimation extends Sprite {

    private var _animationSkillStart:MovieClip;

    private var _side:uint = 0;

    public function PowSkillStartAnimation() {
        super();
        this.initialize();
    }

    public function initData(param1:Object):void {
        this._side = param1["side"];
    }

    public function initialize():void {
        this.mouseChildren = false;
        this.mouseEnabled = false;
    }

    public function play():void {
        if (this._animationSkillStart == null) {
            this._animationSkillStart = new UI_PowerSkillStart;
        }
        addChild(this._animationSkillStart);
        if (this._side == FightSide.RIGHT) {
            this.x = 1200;
            this._animationSkillStart.scaleX = -1;
        }
        Utils.onComplete(this._animationSkillStart, onAnimationEnd)
    }

    public function dispose():void {
        if (this._animationSkillStart != null) {
            this._animationSkillStart.scaleX = 1;
            DisplayUtil.removeForParent(this._animationSkillStart);
            this._animationSkillStart = null;
        }
    }

    private function onAnimationEnd():void {
        dispatchEvent(Events.animationEnd());
    }
}
}
