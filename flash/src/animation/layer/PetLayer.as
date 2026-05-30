package animation.layer {
import animation.event.Events;

import com.greensock.TweenLite;
import com.greensock.easing.Strong;

import data.FightPet;
import data.pet.ArenaData;
import data.pet.ChangeData;
import data.pet.EventData;
import data.pet.FrameData;
import data.pet.MoveData;
import data.pet.PetData;

import enums.FightPosition;
import enums.FightSide;
import enums.FighterActionType;
import enums.SkillCategoryName;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.utils.setTimeout;

import utils.CacheUtils;
import utils.Utils;

public class PetLayer extends Sprite {
    public static const IDLE:String = FighterActionType.IDLE;
    public static const LEFT_SUB:int = 0;
    public static const RIGHT_SUB:int = 1;
    public static const LEFT_MAIN:int = 2;
    public static const RIGHT_MAIN:int = 3;
    private var fighters:Vector.<FightPet>;

    public var bgLayer:BackLayer;
    public var fgLayer:FrontLayer;
    public var soundLayer:SoundLayer;

    public var _version:int;

    public function PetLayer() {
        this.fighters = new Vector.<FightPet>();
        this.fighters.push(FightPet.build(FightSide.LEFT, FightPosition.SUB));
        this.fighters.push(FightPet.build(FightSide.RIGHT, FightPosition.SUB));
        this.fighters.push(FightPet.build(FightSide.LEFT, FightPosition.MAIN));
        this.fighters.push(FightPet.build(FightSide.RIGHT, FightPosition.MAIN));
        for (var idx:int = 0; idx < fighters.length; idx++) {
            addChild(fighters[idx].pet);
        }
    }

    public function initData(frame:FrameData, cb:Function):void {
        _version++;
        var version:int = _version;
        if (frame.move) {
            loadMoveFrame(frame, cb, version);
        } else if (frame.event) {
            loadEventFrame(frame, cb, version);
        } else {
            loadFrame(frame, cb, version);
        }
    }

    private function loadMoveFrame(frame:FrameData, cb:Function, version:int):void {
        var moveData:MoveData = frame.move;
        var moveSides:Vector.<int> = buildMoveSide(moveData.side);
        var atkSide:int = moveSides[0];
        var defSide:int = moveSides[1];
        var atk:MovieClip = fighters[1 + atkSide].pet;
        var def:MovieClip = fighters[1 + defSide].pet;
        setChildIndex(def, 2);
        setChildIndex(atk, 3);
        var moveLabel:String = SkillCategoryName.atkLabel(moveData.category);
        var hitLabel:String = buildHurtLabel(moveData.miss, moveData.critical);
        var pets:Vector.<PetData> = Vector.<PetData>([null, frame.data.left.master, frame.data.right.master]);

        if (FighterActionType.superAtk().indexOf(moveLabel) >= 0) {
            fgLayer.playSuperAtkStart(atkSide);
            bgLayer.vibrate();
            soundLayer.playSkillSound(moveData.soundUrl);
        }
        //播放攻击动画
        updateStatus(atk, moveLabel, version);
        //攻击、受击完成时回调
        Utils.promiseAll([
            function (resolve:Function):void {
                onChild0Complete(atk, function ():void {
                    if (!checkVersion(version)) {
                        return;
                    }
                    //todo 是否切换petSwf
                    updateStatus(atk, buildIdleLabel(pets[atkSide]), version);
                    resolve();
                    //兜底事件
                    atk.dispatchEvent(new Event("hit"));
                })
            },
            function (resolve:Function):void {
                var hits:Vector.<int> = moveData.hits;
                var totalDamage:int = moveData.damage;

                var currentHit:int = 0;
                var expectHitMax:int = 1;
                var hitDamages:Array = [totalDamage];

                //优先使用hit数据
                if (hits && hits.length) {
                    expectHitMax = hits.length;
                    hitDamages = [];
                    //平分伤害并处理余数，防止加起来和实际伤害不等
                    var eachDamage:Number = totalDamage / expectHitMax;
                    for (var i:int = 0; i < expectHitMax - 1; i++) {
                        hitDamages.push(eachDamage);
                    }

                    hitDamages.push(eachDamage + totalDamage % expectHitMax);

                    atk.addEventListener(Event.ENTER_FRAME, handleEachFrame);

                    function handleEachFrame(event:Event):void {
                        var mc:MovieClip = atk.getChildAt(0) as MovieClip;
                        if (mc) {
                            var currentFrame:int = mc.currentFrame;
                            if (hits.indexOf(currentFrame) !== -1) {
                                playHit();
                            }
                            //往前数一帧，防止和前面的onChild0Complete冲突
                            if (currentFrame == mc.totalFrames - 1) {
                                //如果并没播放完，兜底播放完
                                for (var i:int = currentHit; i < expectHitMax; i++) {
                                    playHit();
                                }
                                atk.removeEventListener(Event.ENTER_FRAME, handleEachFrame);
                            }
                        }
                    }
                } else {
                    Utils.once(atk, "hit", playHit);
                }

                function playHit():void {
                    if (!checkVersion(version)) {
                        return;
                    }
                    currentHit++;
                    var hitSnapshot:int = currentHit;
                    var isFirstHit:Boolean = hitSnapshot === 1;
                    var isLastHit:Boolean = hitSnapshot === expectHitMax;
                    var hitDamage:int = hitDamages[hitSnapshot - 1];

                    cb && cb(Events.frameMoveHit());
                    //声音放在第一段打中的时候播放
                    if (isFirstHit && FighterActionType.superAtk().indexOf(moveLabel) < 0) {
                        soundLayer.playSkillSound(moveData.soundUrl);
                    }
                    //特效放在最后一段打中的时候播放
                    if (isLastHit) {
                        fgLayer.playSkillEffect(moveData.effectUrl, atkSide);
                    }
                    if (FighterActionType.ATK_BUF === moveLabel) {
                        updateStatus(def, buildIdleLabel(pets[defSide]), version);
                        if (isLastHit) {
                            resolve();
                        }
                        return;
                    }
                    if (FighterActionType.damage().indexOf(moveLabel) >= 0) {
                        if (hitDamage > 0) {
                            fgLayer.playHpReduceSplash(defSide, hitDamage, moveData.critical, moveData.rate);
                        } else if (moveData.miss > 0) {
                            fgLayer.playMiss(defSide);
                        } else {
                            fgLayer.playAbsorb(defSide);
                        }
                        //多段攻击如果播放暴击或必杀特效会闪瞎眼，只第一帧触发
                        if (isFirstHit && moveData.miss <= 0) {
                            if (FighterActionType.superAtk().indexOf(moveLabel) >= 0) {
                                fgLayer.playSuperAtkHit();
                            }
                            if (moveData.critical > 0) {
                                fgLayer.playCriticalHit();
                                if (moveLabel === FighterActionType.ATK_PHY) {
                                    bgLayer.drift(atkSide);
                                }
                            }
                        }
                        if (isFirstHit && moveData.damage / pets[atkSide].maxHp > 0.33) {
                            bgLayer.vibrate();
                        }
                    }
                    updateStatus(def, hitLabel, version);
                    onChild0Complete(def, function ():void {
                        if (!checkVersion(version)) {
                            return;
                        }
                        if (currentHit !== hitSnapshot) {
                            return;
                        }
                        //todo 是否切换petSwf
                        updateStatus(def, buildIdleLabel(pets[defSide]), version);
                        if (isLastHit) {
                            resolve();
                        }
                    })
                }
            }
        ], function ():void {
            cb && cb(Events.framePlayEnd());
        });
    }

    private function loadEventFrame(frame:FrameData, cb:Function, version:int):void {
        var typ:int = frame.event.type;
        var side:int = frame.event.side;
        var change:int = frame.event.change;
        var delay:int = frame.event.delay;
        if (typ === EventData.CATCH_FAILED) {
            fgLayer.playCatchFailed(function ():void {
                if (!checkVersion(version)) {
                    return;
                }
                loadFrame(frame, cb, version);
            })
            return;
        }
        if (typ === EventData.CATCH_SUCCESS) {
            fgLayer.playCatchSuccess(function ():void {
                loadFrame(frame, function ():void {
                    if (!checkVersion(version)) {
                        return;
                    }
                    var fightPet:FightPet = fighters[RIGHT_MAIN];
                    if (fightPet.pet) {
                        fightPet.url = FightPet.UNREACHABLE_URL;
                        fightPet.pet.visible = false;
                    }
                }, version);
            }, function ():void {
                if (!checkVersion(version)) {
                    return;
                }
                cb && cb(Events.framePlayEnd());
            })
            return;
        }
        if (typ === EventData.PET_EXCHANGE) {
            var main:FightPet = fighters[side === FightSide.RIGHT ? RIGHT_MAIN : LEFT_MAIN];
            var sub:FightPet = fighters[side === FightSide.RIGHT ? RIGHT_SUB : LEFT_SUB];
            Utils.promiseAll([
                function (resolve:Function):void {
                    TweenLite.to(main.pet, 0.5, {
                        "x": sub.x,
                        "y": sub.y,
                        "scaleX": sub.scaleX,
                        "scaleY": sub.scaleY,
                        "ease": Strong.easeIn,
                        "onComplete": resolve
                    });
                },
                function (resolve:Function):void {
                    TweenLite.to(sub.pet, 0.5, {
                        "x": main.x,
                        "y": main.y,
                        "scaleX": main.scaleX,
                        "scaleY": main.scaleY,
                        "ease": Strong.easeIn,
                        "onComplete": resolve
                    });
                }
            ], function ():void {
                if (!checkVersion(version)) {
                    //todo 复原
                    return;
                }
                var mainPet:MovieClip = main.pet;
                main.pet = sub.pet;
                sub.pet = mainPet;
                loadFrame(frame, cb, version);
            });
            return;
        }
        if (typ === EventData.HP_INCREASE) {
            fgLayer.playHPIncrease(side, change)
        } else if (typ === EventData.HP_DECREASE) {
            fgLayer.playHPDecrease(side, change)
        } else if (typ === EventData.ITEM_HP) {
            fgLayer.playItemUse(side, 0, 1, change)
        } else if (typ === EventData.ITEM_ANGER) {
            fgLayer.playItemUse(side, 0, 2, change)
        }
        setTimeout(function ():void {
            loadFrame(frame, cb, version);
        }, delay)
    }

    private function loadFrame(frame:FrameData, cb:Function, version:int):void {
        var arenaData:ArenaData = frame.data;
        var change:ChangeData = frame.change || new ChangeData();
        var winner:int = frame.end ? frame.end.winner : 0;
        var showReplace:int = frame.start ? ChangeData.REPLACE : 0;
        Utils.promiseAll([
            function (resolve:Function):void {
                lazyApplyPet(fighters[LEFT_SUB], arenaData.left.slave, showReplace || 0, version, resolve, winner);
            },
            function (resolve:Function):void {
                lazyApplyPet(fighters[RIGHT_SUB], arenaData.right.slave, showReplace || 0, version, resolve, winner);
            },
            function (resolve:Function):void {
                lazyApplyPet(fighters[LEFT_MAIN], arenaData.left.master, showReplace || change.left, version, resolve, winner);
            },
            function (resolve:Function):void {
                lazyApplyPet(fighters[RIGHT_MAIN], arenaData.right.master, showReplace || change.right, version, resolve, winner);
            }
        ], function ():void {
            cb && cb(Events.framePlayEnd());
        });
    }

    private function updateStatus(pet:MovieClip, label:String, version:int):void {
        if (!Utils.hasLabel(pet, label)) {
            if (FighterActionType.atk().indexOf(label) >= 0) {
                label = FighterActionType.ATK_PHY;
            } else if (FighterActionType.hurt().indexOf(label) >= 0) {
                label = FighterActionType.UNDER_ATK;
            } else {
                label = IDLE;
            }
        }
        pet.gotoAndStop(label);
        if (FighterActionType.end().indexOf(label) >= 0) {
            onChild0Complete(pet, function ():void {
                if (checkVersion(version)) {
                    (pet.getChildAt(0) as MovieClip).stop();
                }
            })
        }
    }

    private function lazyApplyPet(fighter:FightPet, petData:PetData, change:int, version:int, resolve:Function, winner:int):void {
        if (!petData) {
            fighter.url = FightPet.UNREACHABLE_URL;
            fighter.pet.visible = false;
            resolve();
            return;
        }

        var url:String = petData.petSwf;
        var petSound:String = petData.petSound;
        var status:String = buildIdleLabel(petData);
        if (winner === fighter.side) {
            status = FighterActionType.WIN;
        }
        if (!change && fighter.url === url) {
            updateStatus(fighter.pet, status, version);
            resolve();
            return;
        }
        CacheUtils.loadPet(url, function (pet:MovieClip):void {
            if (!checkVersion(version)) {
                return;
            }

            var first:Boolean = true;

            function twiceWillRemove(exist:MovieClip):void {
                if (exist) {
                    if (first) {
                        first = false;
                    } else {
                        removeChild(exist);
                    }
                }
            }

            function petDisappear(exit:MovieClip):void {
                if (exit) {
                    TweenLite.to(exit, 0.5, {
                        "x": fighter.side == FightSide.LEFT ? -200 : 1160,
                        "ease": Strong.easeIn,
                        "onComplete": function ():void {
                            twiceWillRemove(exit);
                            exist.visible = false;
                        },
                        "onCompleteParams": []
                    });
                }
            }

            function applyPet(exist:MovieClip, present:Boolean):void {
                if (exist) {
                    twiceWillRemove(exist);
                }
                addChildAt(pet, fighter.depth);
                pet.x = fighter.x;
                pet.y = fighter.y;
                pet.scaleX = fighter.scaleX;
                pet.scaleY = fighter.scaleY;
                fighter.url = url;
                fighter.pet = pet;

                if (present && Utils.hasLabel(pet, FighterActionType.PRESENT)) {
                    pet.gotoAndStop(FighterActionType.PRESENT);
                    onChild0Complete(pet, function ():void {
                        if (!checkVersion(version)) {
                            return;
                        }
                        updateStatus(pet, status, version);
                        //resolve();//胶囊动画时resolve应该在动画结束后调用，为适配这个，改变了resolve位置
                    });
                } else {
                    updateStatus(pet, status, version);
                    //resolve();
                }
            }

            var exist:MovieClip = fighter.pet;
            //morph
            if (change === ChangeData.MORPH && exist && Utils.hasLabel(exist, FighterActionType.CHANGE_STATUS)) {
                setChildIndex(exist, 3);
                updateStatus(exist, FighterActionType.CHANGE_STATUS, version);
                onChild0Complete(exist, function ():void {
                    if (!checkVersion(version)) {
                        return;
                    }
                    twiceWillRemove(exist);
                    applyPet(exist, false);
                    resolve();
                })
            }
            //replace
            else if (change === ChangeData.REPLACE) {
                if (fighter.side === FightSide.LEFT) {
                    petDisappear(exist);
                    fgLayer.playLeftPresent(function ():void {
                        if (!checkVersion(version)) {
                            if (exist) {
                                exist.x = fighter.x;
                                exist.visible = true;
                            }
                            return;
                        }
                        soundLayer.playPetSound(petSound);
                        applyPet(exist, false);
                    }, resolve);
                } else {
                    petDisappear(exist);
                    applyPet(exist, true);
                    resolve();
                }
            }
            //fallback
            else {
                twiceWillRemove(exist);
                applyPet(exist, false);
                resolve();
            }
        });
    }

    private function checkVersion(version:int):Boolean {
        return this._version === version;
    }

    private function buildIdleLabel(pet:PetData):String {
        if (pet.alive <= 0) {
            return FighterActionType.DEAD;
        } else if (pet.hp < pet.maxHp * 0.2) {
            return FighterActionType.ABOUT_TO_DIE;
        } else {
            return FighterActionType.IDLE;
        }
    }

    private function buildHurtLabel(miss:int, critical:int):String {
        if (miss > 0) {
            return FighterActionType.MISS;
        }
        if (critical > 0) {
            return FighterActionType.UNDER_ULTRA;
        }
        return FighterActionType.UNDER_ATK;
    }

    private function buildMoveSide(side:int):Vector.<int> {
        if (side == FightSide.LEFT) {
            return Vector.<int>([FightSide.LEFT, FightSide.RIGHT]);
        }
        return Vector.<int>([FightSide.RIGHT, FightSide.LEFT]);
    }

    private function onChild0Complete(pet:MovieClip, cb:Function):void {
        pet.addEventListener(Event.ENTER_FRAME, handleEnterFrame);

        function handleEnterFrame(event:Event):void {
            var mc:MovieClip = pet.getChildAt(0) as MovieClip;
            if (mc && mc.currentFrame == mc.totalFrames) {
                pet.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
                cb();
            }
        }
    }
}
}
