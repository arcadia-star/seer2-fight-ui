package animation.fight {


import animation.event.Events;

import flash.display.MovieClip;
import flash.display.Sprite;

import ui.splash.UI_FightPresent;

import utils.Utils;

public class PresentAnimation extends Sprite {

    private var _animation:MovieClip;

    private var _onFighterPresent:Function;

    public function PresentAnimation() {
        super();
        this.initialize();
    }

    public function initData(param1:Object):void {
        this._onFighterPresent = param1["onFighterPresentFun"];
    }

    public function initialize():void {
        if (this._animation == null) {
            this._animation = new UI_FightPresent;
        }
        this._animation.stop();
        addChild(this._animation);
    }

    private function onPresent():void {
        if (this._onFighterPresent != null) {
            this._onFighterPresent();
            this._onFighterPresent = null;
        }
    }

    private function onAnimationEnd():void {
        dispatchEvent(Events.animationEnd());
    }

    public function play():void {
        //addChild(this._animation);
        this._animation.play();
        Utils.once(this._animation, "present", onPresent);
        Utils.once(this._animation, "end", onAnimationEnd);
    }

    public function dispose():void {
        this._animation = null;
        this._onFighterPresent = null;
    }
}
}
