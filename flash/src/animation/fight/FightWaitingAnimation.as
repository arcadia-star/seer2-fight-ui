package animation.fight {
import flash.display.Sprite;

import ui.splash.UI_FightWaiting;

import utils.an.DisplayObjectUtil;

public class FightWaitingAnimation extends Sprite {

    private var _waitingSprite:Sprite;

    public function FightWaitingAnimation() {
        super();
        this.initialize();
    }

    public function initialize():void {
        DisplayObjectUtil.disableSprite(this);
        if (this._waitingSprite == null) {
            this._waitingSprite = new UI_FightWaiting;
        }
    }

    public function play():void {
        this._waitingSprite.x = 1200 / 2;
        this._waitingSprite.y = 180;
        addChild(this._waitingSprite);
    }

    public function dispose():void {
        DisplayObjectUtil.removeFromParent(this._waitingSprite);
        this._waitingSprite = null;
    }
}
}
