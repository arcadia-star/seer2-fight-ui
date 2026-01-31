package animation.fight {

import animation.event.Events;

import com.greensock.TweenLite;
import com.greensock.easing.Expo;

import enums.FightSide;

import flash.display.MovieClip;
import flash.display.Sprite;

import ui.splash.UI_FightHpRecover;
import ui.splash.UI_NumberHpIncreaseN;
import ui.splash.UI_NumberHpIncreasePlus;

import utils.NumberUtil;
import utils.Utils;
import utils.an.DisplayObjectUtil;
import utils.an.DisplayUtil;

public class HPIncreaseAnimation extends Sprite {

    private var _hpRecoverAnimation:MovieClip;

    private var _digitSprite:Sprite;

    private var _fightSide:uint;

    private var _changedHp:uint;

    private var _startInterval:uint;

    public function HPIncreaseAnimation() {
        super();
        this.initialize();
    }

    public function initialize():void {
        DisplayObjectUtil.disableSprite(this);
    }

    public function initData(param1:Object):void {
        this._fightSide = param1["fightSide"];
        this._changedHp = param1["changedHp"];
        this._startInterval = param1["startInterval"];
    }

    public function play():void {
        if (this._hpRecoverAnimation == null) {
            this._hpRecoverAnimation = new UI_FightHpRecover;
        }
        this.deployAnimation(this._hpRecoverAnimation, this._fightSide);
        addChild(this._hpRecoverAnimation);
        Utils.onComplete(this._hpRecoverAnimation, onAnimationEnd);
        this._digitSprite = this.createNumberSprite(this._changedHp);
        addChild(this._digitSprite);
        this.deployDigitSprite(this._digitSprite, this._fightSide, this._startInterval);
    }

    private function onAnimationUpdate():void {
    }

    public function dispose():void {
        DisplayUtil.removeForParent(this._hpRecoverAnimation);
        this._hpRecoverAnimation = null;
    }

    private function onAnimationEnd():void {
        DisplayUtil.removeForParent(this._hpRecoverAnimation);
        dispatchEvent(Events.animationEnd());
    }

    private function deployDigitSprite(param1:Sprite, param2:uint, param3:uint):void {
        var targetY:int;
        var onAnimateComplete:Function = null;
        var onPlayComplete:Function = null;
        var digitSprite:Sprite = param1;
        var fightSide:uint = param2;
        var startInterval:uint = param3;
        onAnimateComplete = function ():void {
            TweenLite.to(_digitSprite, 2, {
                "alpha": 0,
                "ease": Expo.easeOut,
                "onComplete": onPlayComplete
            });
        };
        onPlayComplete = function ():void {
            DisplayObjectUtil.removeFromParent(_digitSprite);
            _digitSprite = null;
        };
        if (fightSide == FightSide.LEFT) {
            digitSprite.x = 200;
        } else {
            digitSprite.x = 760;
        }
        digitSprite.y = 250 + startInterval;
        targetY = 100 + startInterval;
        TweenLite.to(digitSprite, 2, {
            "y": targetY,
            "ease": Expo.easeOut,
            "onComplete": onAnimateComplete
        });
    }

    private function deployAnimation(param1:MovieClip, param2:uint):void {
        if (param2 == FightSide.LEFT) {
            param1.x = 0;
        } else {
            param1.scaleX = -1;
            param1.x = 1200;
        }
    }

    private function createNumberSprite(param2:int):Sprite {
        var _loc9_:Sprite = null;
        var _loc3_:int = 25;
        var _loc4_:Sprite = new Sprite();
        var _loc5_:Sprite = new UI_NumberHpIncreasePlus;
        _loc4_.addChild(_loc5_);
        var _loc6_:Vector.<int>;
        var _loc7_:int = int((_loc6_ = NumberUtil.parseNumberToDigitVec(param2)).length);
        var _loc8_:int = 0;
        while (_loc8_ < _loc7_) {
            (_loc9_ = new (UI_NumberHpIncreaseN.find(_loc6_[_loc8_]))).x = (_loc8_ + 1) * _loc3_;
            _loc4_.addChild(_loc9_);
            _loc8_++;
        }
        return _loc4_;
    }
}
}
