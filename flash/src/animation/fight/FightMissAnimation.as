package animation.fight {

import animation.event.Events;

import com.greensock.TweenLite;
import com.greensock.easing.Expo;

import enums.FightSide;

import flash.display.Sprite;

import ui.splash.UI_FightMiss;

import utils.an.DisplayObjectUtil;
import utils.an.DisplayUtil;

public class FightMissAnimation extends Sprite {


    private var _missSprite:Sprite;

    private var _side:uint;

    public function FightMissAnimation() {
        super();
        this.initialize();
    }

    public function initData(param1:Object):void {
        this._side = param1["side"];
    }

    public function initialize():void {
        DisplayObjectUtil.disableSprite(this);
        if (this._missSprite == null) {
            this._missSprite = new UI_FightMiss;
        }
        addChild(this._missSprite);
    }

    public function play():void {
        if (this._side == FightSide.LEFT) {
            this.x = 250;
            this.y = 200;
        }
        if (this._side == FightSide.RIGHT) {
            this.x = 710;
            this.y = 200;
        }
        var _loc1_:int = 50;
        TweenLite.to(this, 1, {
            "y": _loc1_,
            "ease": Expo.easeOut,
            "onComplete": this.onAnimateComplete
        });
    }

    private function onAnimateComplete():void {
        TweenLite.to(this, 1, {
            "alpha": 0,
            "ease": Expo.easeOut,
            "onComplete": this.onPlayComplete
        });
    }

    private function onPlayComplete():void {
        dispatchEvent(Events.animationEnd());
    }

    public function dispose():void {
        TweenLite.killTweensOf(this);
        DisplayUtil.removeForParent(this._missSprite);
        this._missSprite = null;
    }
}
}
