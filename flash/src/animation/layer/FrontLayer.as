package animation.layer {

import animation.event.Events;
import animation.fight.BaoJiHitAnimation;
import animation.fight.BuffDisabledAnimation;
import animation.fight.CatchFighterFailAnimation;
import animation.fight.CatchFighterSuccessAnimation;
import animation.fight.CatchHintAnimation;
import animation.fight.FightAbsorbAnimation;
import animation.fight.FightCountDownAnimation;
import animation.fight.FightMissAnimation;
import animation.fight.FightWaitingAnimation;
import animation.fight.HPIncreaseAnimation;
import animation.fight.HpDecreaseAnimation;
import animation.fight.ItemUseAnimation;
import animation.fight.KOAnimation;
import animation.fight.PowSkillHitAnimation;
import animation.fight.PowSkillStartAnimation;

import com.greensock.TweenLite;

import data.FightPet;
import data.location.FighterLocation;

import enums.FightPosition;
import enums.FightSide;
import enums.SkillTypeRelation;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;

import ui.splash.UI_FightPresent;

import utils.CacheUtils;
import utils.Utils;
import utils.an.DisplayObjectUtil;

public class FrontLayer extends Sprite {
    private var currentSkillEffectUrl:String;

    public function playHitTips(tipIds:Vector.<int>, side:int):void {
        for (var index:int = 0; index < tipIds.length; index++) {
            var animation:BuffDisabledAnimation = new BuffDisabledAnimation(tipIds[index], side);
            animation.visible = false;
            addChild(animation);
            animation.addEventListener(Events.ANIMATION_END, onBuffTipEnd);
            TweenLite.delayedCall(index * 0.5, startBuffTip, [animation]);
        }
    }

    private function startBuffTip(animation:BuffDisabledAnimation):void {
        animation.visible = true;
        animation.play();
    }

    private function onBuffTipEnd(event:Event):void {
        var animation:BuffDisabledAnimation = event.currentTarget as BuffDisabledAnimation;
        animation.removeEventListener(Events.ANIMATION_END, onBuffTipEnd);
        DisplayObjectUtil.removeFromParent(animation);
    }

    public function FrontLayer() {
        DisplayObjectUtil.disableSprite(this);
    }

    public function playSuperAtkStart(side:int):void {
        var sprite:PowSkillStartAnimation = new PowSkillStartAnimation;
        sprite.initData({
            "side": side
        });
        addChild(sprite);
        sprite.play();
        Utils.once(sprite, Events.ANIMATION_END, function ():void {
            DisplayObjectUtil.removeFromParent(sprite);
        })
    }

    public function playHpReduceSplash(side:int, damage:int, critical:int, rate:int):void {
        if (damage <= 0) {
            return;
        }
        var skillTypeRelation:int = SkillTypeRelation.YIBAN;
        if (rate > 100) {
            skillTypeRelation = SkillTypeRelation.KEZHI;
        } else if (rate < 100) {
            skillTypeRelation = SkillTypeRelation.WEIRUO;
        }
        var sprite:HpDecreaseAnimation = new HpDecreaseAnimation;
        sprite.initData({
            "reducedHp": damage,
            "fightSide": side,
            "isBaoJi": critical,
            "skillTypeRelation": skillTypeRelation
        });
        addChild(sprite);
        sprite.play();
        Utils.once(sprite, Events.ANIMATION_END, function ():void {
            DisplayObjectUtil.removeFromParent(sprite);
        })
    }

    public function playSuperAtkHit():void {
        var sprite:PowSkillHitAnimation = new PowSkillHitAnimation;
        addChild(sprite);
        sprite.play();
        Utils.once(sprite, Events.ANIMATION_END, function ():void {
            DisplayObjectUtil.removeFromParent(sprite);
        })
    }

    public function playCriticalHit():void {
        var sprite:BaoJiHitAnimation = new BaoJiHitAnimation;
        addChild(sprite);
        sprite.play();
        Utils.once(sprite, Events.ANIMATION_END, function ():void {
            DisplayObjectUtil.removeFromParent(sprite);
        })
    }

    public function playLeftPresent(fighter:FightPet, onPresent:Function, onComplete:Function):void {
        var capsule:UI_FightPresent = new UI_FightPresent();
        // 素材以左侧主位为锚点，副位沿用精灵本身的缩放和站位。
        var main:FighterLocation = FighterLocation.build(FightSide.LEFT, FightPosition.MAIN);
        capsule.scaleX = fighter.scaleX;
        capsule.scaleY = fighter.scaleY;
        capsule.x = fighter.x - main.targetX * capsule.scaleX;
        capsule.y = fighter.y - main.targetY * capsule.scaleY;

        Utils.once(capsule, "present", onPresent);
        Utils.once(capsule, "end", function ():void {
            onComplete();
            DisplayObjectUtil.removeFromParent(capsule);
        });
        addChild(capsule);
        capsule.play();
    }

    public function playHPIncrease(side:int, change:int):void {
        var sprite:HPIncreaseAnimation = new HPIncreaseAnimation;
        addChild(sprite);
        sprite.initData({
            "fightSide": side,
            "changedHp": change,
            "startInterval": 0
        });
        sprite.play();
        Utils.once(sprite, Events.ANIMATION_END, function ():void {
            DisplayObjectUtil.removeFromParent(sprite);
        })
    }

    public function playHPDecrease(side:int, change:int):void {
        playHpReduceSplash(side, change, 0, 100);
    }

    public function playItemUse(side:int, position:int, type0:int, change:int):void {
        var sprite:ItemUseAnimation = new ItemUseAnimation;
        addChild(sprite);
        sprite.initData({
            "side": side,
            "position": position,
            "type": type0,
            "change": change
        });
        sprite.play();
        Utils.once(sprite, Events.ANIMATION_END, function ():void {
            DisplayObjectUtil.removeFromParent(sprite);
        })
    }

    public function playAbsorb(side:int):void {
        var sprite:FightAbsorbAnimation = new FightAbsorbAnimation;
        addChild(sprite);
        sprite.initData({
            "side": side
        });
        sprite.play();
        Utils.once(sprite, Events.ANIMATION_END, function ():void {
            DisplayObjectUtil.removeFromParent(sprite);
        })
    }

    public function playMiss(side:int):void {
        var sprite:FightMissAnimation = new FightMissAnimation;
        addChild(sprite);
        sprite.initData({
            "side": side
        });
        sprite.play();
        Utils.once(sprite, Events.ANIMATION_END, function ():void {
            DisplayObjectUtil.removeFromParent(sprite);
        })
    }

    public function playKO(cb:Function):void {
        var sprite:KOAnimation = new KOAnimation;
        addChild(sprite);
        sprite.play();
        Utils.once(sprite, Events.ANIMATION_END, function ():void {
            DisplayObjectUtil.removeFromParent(sprite);
            cb();
        })
    }

    public function playCountDown(cb:Function):void {
        var sprite:FightCountDownAnimation = new FightCountDownAnimation;
        addChild(sprite);
        sprite.play();
        Utils.once(sprite, Events.ANIMATION_END, function ():void {
            DisplayObjectUtil.removeFromParent(sprite);
            cb();
        })
    }

    public function playFightWaiting():void {
        var sprite:FightWaitingAnimation = new FightWaitingAnimation;
        addChild(sprite);
        sprite.play();
        Utils.once(sprite, Events.ANIMATION_END, function ():void {
            DisplayObjectUtil.removeFromParent(sprite);
        })
    }

    public function playSkillEffect(url:String, side:int):void {
        if (!url) {
            return;
        }
        currentSkillEffectUrl = url;
        CacheUtils.loadEffect(url, function (sprite:MovieClip):void {
            if (currentSkillEffectUrl !== url) {
                return
            }
            addChild(sprite);
            sprite.gotoAndPlay(1);
            var location:FighterLocation = FighterLocation.build(side, 1);
            sprite.x = location.targetX;
            sprite.y = location.targetY;
            if (side === FightSide.RIGHT) {
                sprite.scaleX *= -1;
            }
            Utils.onComplete(sprite, function ():void {
                DisplayObjectUtil.removeFromParent(sprite);
            })
        })
    }

    public function playCatchHit():void {
        var sprite:CatchHintAnimation = new CatchHintAnimation;
        addChild(sprite);
        sprite.play();
        Utils.once(sprite, Events.ANIMATION_END, function ():void {
            DisplayObjectUtil.removeFromParent(sprite);
        })
    }

    public function playCatchSuccess(onSuccess:Function, cb:Function):void {
        var sprite:CatchFighterSuccessAnimation = new CatchFighterSuccessAnimation;
        addChild(sprite);
        sprite.initData({
            "onCatchSuccessFun": onSuccess
        });
        sprite.play();
        Utils.once(sprite, Events.ANIMATION_END, function ():void {
            DisplayObjectUtil.removeFromParent(sprite);
            cb();
        })
    }

    public function playCatchFailed(cb:Function):void {
        var sprite:CatchFighterFailAnimation = new CatchFighterFailAnimation;
        addChild(sprite);
        sprite.play();
        Utils.once(sprite, Events.ANIMATION_END, function ():void {
            DisplayObjectUtil.removeFromParent(sprite);
            cb();
        })
    }
}
}
