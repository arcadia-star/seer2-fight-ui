package animation.status {
import com.greensock.TweenLite;
import com.greensock.easing.Strong;

import data.pet.PetData;

import enums.FightSide;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import ui.status.UI_FightAngerLeft;
import ui.status.UI_FightAngerRight;

import utils.an.DisplayObjectUtil;

internal class AngerStatusPanel extends Sprite {

    private var _side:uint;

    private var _bubble:MovieClip;

    private var _prevAnger:int;

    private var _fight:PetData;

    private var _setTimeout:uint;

    public function AngerStatusPanel(param1:uint) {
        super();
        this._side = param1;
    }

    public function setFight(param1:PetData):void {
        this._fight = param1;
        this._prevAnger = param1.anger;
    }

    public function update():void {
        var _loc1_:MovieClip = null;
        var _loc2_:int = 0;
        if (this._fight.anger == this._prevAnger) {
            return;
        }
        if (this._fight.anger > this._prevAnger) {
            _loc1_ = new UI_FightAngerLeft;
            _loc2_ = this._fight.anger - this._prevAnger;
        } else if (this._fight.anger < this._prevAnger) {
            _loc1_ = new UI_FightAngerRight;
            _loc2_ = this._prevAnger - this._fight.anger;
        }
        this.dispose();
        this._bubble = _loc1_;
        addChild(this._bubble);
        this._bubble.x = this._side == FightSide.LEFT ? 335 : 755;
        this._bubble.y = 125;
        this._bubble["num0"].gotoAndStop(uint(_loc2_ / 10) + 1);
        this._bubble["num1"].gotoAndStop(_loc2_ % 10 + 1);
        this.emerge();
        this._prevAnger = this._fight.anger;
    }

    private function emerge():void {
        var _loc1_:int = 58;
        TweenLite.to(this._bubble, 0.3, {
            "y": _loc1_,
            "ease": Strong.easeIn,
            "onComplete": this.onEmerge
        });
    }

    private function onEmerge():void {
        this._setTimeout = setTimeout(this.shrink, 1500);
    }

    private function shrink():void {
        this.dispose();
    }

    public function dispose():void {
        TweenLite.killTweensOf(this._bubble);
        clearTimeout(this._setTimeout);
        DisplayObjectUtil.removeFromParent(this._bubble);
        this._bubble = null;
    }
}
}
