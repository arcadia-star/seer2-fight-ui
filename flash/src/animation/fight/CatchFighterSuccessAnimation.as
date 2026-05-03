package animation.fight {


import animation.event.Events;

import flash.display.MovieClip;
import flash.display.Sprite;

import ui.splash.UI_FightCatchSuccess;

import utils.Utils;
import utils.an.DisplayObjectUtil;

public class CatchFighterSuccessAnimation extends Sprite {

    private var _onCatchSuccess:Function;

    private var _successAnimation:MovieClip;

    public function CatchFighterSuccessAnimation() {
        super();
        this.initialize();
    }

    public function initData(param1:Object):void {
        this._onCatchSuccess = param1["onCatchSuccessFun"];
    }

    public function initialize():void {
        this.mouseChildren = false;
        this.mouseEnabled = false;
    }

    public function play():void {
        if (this._successAnimation == null) {
            this._successAnimation = new UI_FightCatchSuccess;
            this._successAnimation.scaleX = -1;
            this._successAnimation.x = 1200 - 50;
        }
        addChild(this._successAnimation);
        Utils.onComplete(this._successAnimation, onAnimationEnd);
        Utils.once(_successAnimation, "success", onSuccess);
    }

    private function onAnimationEnd():void {
        DisplayObjectUtil.removeFromParent(this._successAnimation);
        dispatchEvent(Events.animationEnd());
    }

    private function onSuccess():void {
        if (this._onCatchSuccess != null) {
            this._onCatchSuccess();
            this._onCatchSuccess = null;
        }
    }

    public function dispose():void {
        if (this._successAnimation != null) {
            this._successAnimation.scaleX = 1;
            this._successAnimation.gotoAndStop(this._successAnimation.totalFrames);
            DisplayObjectUtil.removeFromParent(this._successAnimation);
            this._successAnimation = null;
        }
        this._onCatchSuccess = null;
    }
}
}
