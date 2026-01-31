package animation.fight {


import animation.event.Events;

import flash.display.MovieClip;
import flash.display.Sprite;

import ui.splash.UI_FightCatchHint;

import utils.Utils;
import utils.an.DisplayObjectUtil;

public class CatchHintAnimation extends Sprite {


    private var _mc:MovieClip;


    public function CatchHintAnimation() {
        super();
        this.initialize();
    }

    public function initialize():void {
        DisplayObjectUtil.disableSprite(this);
        this._mc = new UI_FightCatchHint;
        this._mc.y = 128;
        this._mc.gotoAndStop(1);
        addChild(this._mc);
    }

    public function play():void {
        this._mc.play();
        Utils.onComplete(this._mc, onAnimationEnd);
    }

    private function onAnimationEnd():void {
        dispatchEvent(Events.animationEnd());
    }

    public function dispose():void {
        if (this._mc != null) {
            DisplayObjectUtil.removeFromParent(this._mc);
            this._mc = null;
        }
    }
}
}
