package animation.fight {

import animation.event.Events;

import com.greensock.TweenLite;
import com.greensock.easing.Expo;

import enums.FightSide;

import flash.display.Sprite;

import ui.splash.UI_FightAbsorb;

import utils.an.DisplayObjectUtil;

public class FightAbsorbAnimation extends Sprite {


    private var _absorbSprite:Sprite;

    private var _side:uint;

    public function FightAbsorbAnimation() {
        super();
        this.initialize();
    }

    public function initData(param1:Object):void {
        this._side = param1["side"];
    }

    public function initialize():void {
        DisplayObjectUtil.disableSprite(this);
        if (this._absorbSprite == null) {
            this._absorbSprite = new UI_FightAbsorb;
        }
        addChild(this._absorbSprite);
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
        DisplayObjectUtil.removeFromParent(this._absorbSprite);
        TweenLite.killTweensOf(this);
        this._absorbSprite = null;
    }
}
}
