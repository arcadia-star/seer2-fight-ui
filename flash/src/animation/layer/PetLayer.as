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
    private var fighters:Vector.<FightPet>;

    public var bgLayer:BackLayer;
    public var fgLayer:FrontLayer;
    public var soundLayer:SoundLayer;

    public var _version:int;

    public function PetLayer() {
        this.fighters = new Vector.<FightPet>();
        this.fighters.push(null);
        this.fighters.push(FightPet.build(FightSide.LEFT));
        this.fighters.push(FightPet.build(FightSide.RIGHT));
        addChild(new Sprite());
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
        var atk:MovieClip = fighters[atkSide].pet;
        var def:MovieClip = fighters[defSide].pet;
        setChildIndex(def, 1);
        setChildIndex(atk, 2);
        var moveLabel:String = SkillCategoryName.atkLabel(moveData.category);
        var hitLabel:String = buildHurtLabel(moveData.miss, moveData.critical);
        var pets:Vector.<PetData> = Vector.<PetData>([null, frame.data.left.master, frame.data.right.master]);

        if (FighterActionType.superAtk().indexOf(moveLabel) >= 0) {
            fgLayer.playSuperAtkStart(atkSide);
            bgLayer.vibrate();
            soundLayer.playSkillSound(moveData.soundUrl);
        }
        updateStatus(atk, moveLabel, version);
        Utils.promiseAll([
            function (resolve:Function):void {
                onChild0Complete(atk, function ():void {
                    if (!checkVersion(version)) {
                        return;
                    }
                    updateStatus(atk, buildIdleLabel(pets[atkSide]), version);
                    resolve();
                    atk.dispatchEvent(new Event("hit"))
                })
            },
            function (resolve:Function):void {
                Utils.once(atk, "hit", function ():void {
                    if (!checkVersion(version)) {
                        return;
                    }
                    cb && cb(Events.frameMoveHit());
                    if (FighterActionType.superAtk().indexOf(moveLabel) < 0) {
                        soundLayer.playSkillSound(moveData.soundUrl);
                    }
                    fgLayer.playSkillEffect(moveData.effectUrl);
                    if (FighterActionType.ATK_BUF === moveLabel) {
                        updateStatus(def, buildIdleLabel(pets[defSide]), version);
                        resolve();
                        return;
                    }
                    if (FighterActionType.damage().indexOf(moveLabel) >= 0) {
                        if (moveData.damage > 0) {
                            fgLayer.playHpReduceSplash(defSide, moveData.damage, moveData.critical, moveData.rate);
                        } else if (moveData.miss > 0) {
                            fgLayer.playMiss(defSide);
                        } else {
                            fgLayer.playAbsorb(defSide);
                        }
                        if (moveData.miss <= 0) {
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
                        if (moveData.damage / pets[atkSide].maxHp > 0.33) {
                            bgLayer.vibrate();
                        }
                    }
                    updateStatus(def, hitLabel, version);
                    onChild0Complete(def, function ():void {
                        if (!checkVersion(version)) {
                            return;
                        }
                        updateStatus(def, buildIdleLabel(pets[defSide]), version);
                        resolve();
                    })
                });
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
                    var fightPet:FightPet = fighters[FightSide.RIGHT];
                    if (fightPet.pet) {
                        fightPet.url = null;
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
        var left:PetData = arenaData.left.master;
        var right:PetData = arenaData.right.master;
        var leftLabel:String = buildIdleLabel(left);
        var rightLabel:String = buildIdleLabel(right);
        var change:ChangeData = frame.change || new ChangeData();
        Utils.promiseAll([
            function (resolve:Function):void {
                lazyApplyPet(FightSide.LEFT, left, leftLabel, change.left, version, resolve);
            },
            function (resolve:Function):void {
                lazyApplyPet(FightSide.RIGHT, right, rightLabel, change.right, version, resolve);
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

    private function lazyApplyPet(side:int, petData:PetData, status:String, change:int, version:int, resolve:Function):void {
        var url:String = petData.petSwf;
        var petSound:String = petData.petSound;
        var fighter:FightPet = fighters[side];
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
                        "x": side == FightSide.LEFT ? -200 : 1160,
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
                addChild(pet);
                pet.x = fighter.x;
                pet.y = fighter.y;
                pet.scaleX = fighter.scaleX;
                fighter.url = url;
                fighter.pet = pet;

                if (present && Utils.hasLabel(pet, FighterActionType.PRESENT)) {
                    pet.gotoAndStop(FighterActionType.PRESENT);
                    onChild0Complete(pet, function ():void {
                        if (!checkVersion(version)) {
                            return;
                        }
                        updateStatus(pet, status, version);
                        resolve();
                    });
                } else {
                    updateStatus(pet, status, version);
                    resolve();
                }
            }

            var exist:MovieClip = fighter.pet;
            //morph
            if (change === 2 && exist && Utils.hasLabel(exist, FighterActionType.CHANGE_STATUS)) {
                updateStatus(exist, FighterActionType.CHANGE_STATUS, version);
                onChild0Complete(exist, function ():void {
                    if (!checkVersion(version)) {
                        return;
                    }
                    twiceWillRemove(exist);
                    applyPet(exist, false);
                })
            }
            //replace
            else if (change === 1) {
                if (side === FightSide.LEFT) {
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
                    });
                } else {
                    petDisappear(exist);
                    applyPet(exist, true);
                }
            }
            //fallback
            else {
                twiceWillRemove(exist);
                applyPet(exist, false);
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
