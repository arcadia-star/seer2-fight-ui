package {
import com.greensock.TweenLite;
import com.greensock.easing.Strong;

import flash.display.LoaderInfo;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.system.ApplicationDomain;
import flash.utils.setTimeout;

[SWF(width="1200", height="660", frameRate="24")]
public class FightPlayer extends Sprite {
    public static const IDLE:String = FighterActionType.IDLE;
    public static const DEFAULT_JS_DISPATCH:String = "flash_dispatch";
    public static const DEFAULT_SWF_URL:String = "http://seer2.61.com/res/pet/fight/31.swf";
    public static const AS_PLAY_FIGHT:String = "flash_playFight";
    public static const AS_UPDATE_PET:String = "flash_updatePet";
    private static const LEFT:int = 1;
    private static const RIGHT:int = 2;
    private static const RES_CACHE:LRUCache = new LRUCache(50);

    public function FightPlayer() {
        var params:Object = LoaderInfo(this.root.loaderInfo).parameters;
        var jsDispatchEvent:String = params["cb"] || DEFAULT_JS_DISPATCH;
        var leftUrl:String = params["url"] || DEFAULT_SWF_URL;
        var rightUrl:String = params["url2"] || DEFAULT_SWF_URL;
        var silence:Boolean = params["silence"] || false;

        var fighters:Vector.<Fighter> = Vector.<Fighter>([null, initFighter(LEFT), initFighter(RIGHT)]);

        var bgLayer:Sprite = new Sprite();
        var petLayer:Sprite = new Sprite();
        var fgLayer:Sprite = new Sprite();
        addChild(bgLayer);
        addChild(petLayer);
        addChild(fgLayer);
        Utils.addCallbackJs(AS_PLAY_FIGHT, playFight);
        Utils.addCallbackJs(AS_UPDATE_PET, updatePet);

        var fightPresentMc:MovieClip;
        Utils.loadSwf("UI_Arena.swf", function (domain:ApplicationDomain):void {
            var UI_FightPresent:Class = domain.getDefinition("UI_FightPresent") as Class;
            fightPresentMc = new UI_FightPresent();
            fightPresentMc.stop();
            fgLayer.addChild(fightPresentMc);
            Utils.callJs(jsDispatchEvent, FightEventType.INIT, {params: params});

            if (!silence) {
                updatePet({leftUrl: leftUrl, rightUrl: rightUrl}, 1);
                setTimeout(function ():void {
                    updatePet({
                        leftUrl: "http://seer2.61.com/res/pet/fight/3.swf",
                        rightUrl: "http://seer2.61.com/res/pet/fight/3.swf"
                    }, 2);
                }, 5000);
                setTimeout(function ():void {
                    updatePet({
                        leftUrl: "http://seer2.61.com/res/pet/fight/31.swf",
                        rightUrl: "http://seer2.61.com/res/pet/fight/31.swf"
                    }, 3);
                }, 10000);
            }
        });

        function updatePet(data:Object, version:Object):void {
            var leftUrl:String = data['leftUrl'] || DEFAULT_SWF_URL;
            var rightUrl:String = data['rightUrl'] || DEFAULT_SWF_URL;
            var leftLabel:String = data['leftLabel'] || IDLE;
            var rightLabel:String = data['rightLabel'] || IDLE;
            var change:Boolean = data['change'] || false;

            Utils.promiseAll([
                function (resolve:Function):void {
                    lazyApplyPet(LEFT, leftUrl, leftLabel, change, version, resolve);
                },
                function (resolve:Function):void {
                    lazyApplyPet(RIGHT, rightUrl, rightLabel, change, version, resolve);
                }
            ], function ():void {
                Utils.callJs(jsDispatchEvent, FightEventType.READY, data, version);
            });
        }

        function playFight(data:Object, version:Object):void {
            var moveSide:int = data['moveSide'] || LEFT;
            var moveLabel:String = data['moveLabel'] || FighterActionType.ATK_PHY;
            var hitLabel:String = data['hitLabel'] || FighterActionType.UNDER_ATK;
            var leftLabel:String = data['leftLabel'] || IDLE;
            var rightLabel:String = data['rightLabel'] || IDLE;

            Utils.callJs(jsDispatchEvent, FightEventType.PLAY, data, version);
            var atkSide:int = moveSide == LEFT ? LEFT : RIGHT;
            var defSide:int = atkSide == RIGHT ? LEFT : RIGHT;
            var atkLabel:String = atkSide == LEFT ? leftLabel : rightLabel;
            var defLabel:String = atkSide == RIGHT ? leftLabel : rightLabel;

            var atk:MovieClip = fighters[atkSide].pet;
            var def:MovieClip = fighters[defSide].pet;

            updateDepth(defSide, 1);
            updateDepth(atkSide, 2);

            updateStatus(atkSide, moveLabel, version);
            Utils.callJs(jsDispatchEvent, FightEventType.MOVE_START, {}, version);
            Utils.promiseAll([
                function (resolve:Function):void {
                    onComplete(atk, function ():void {
                        updateStatus(atkSide, atkLabel, version);
                        resolve();
                        atk.dispatchEvent(new Event("hit"))
                    })
                },
                function (resolve:Function):void {
                    Utils.once(atk, "hit", function ():void {
                        updateStatus(defSide, hitLabel, version);
                        Utils.callJs(jsDispatchEvent, FightEventType.HIT, {}, version);
                        onComplete(def, function ():void {
                            updateStatus(defSide, defLabel, version);
                            resolve();
                        })
                    });
                }
            ], function ():void {
                Utils.callJs(jsDispatchEvent, FightEventType.MOVE_END, {}, version);
            });
        }

        function updateStatus(side:int, label:String, version:Object):void {
            Utils.callJs(jsDispatchEvent, FightEventType.INFO, "updateStatus side:" + side + " label:" + label, version);
            if (side !== LEFT && side !== RIGHT) {
                return;
            }
            fighters[side].status = label;
            var mc:MovieClip = fighters[side].pet;
            if (Utils.hasLabel(mc, label)) {
                mc.gotoAndStop(label);
                if (FighterActionType.end().indexOf(label) >= 0) {
                    onComplete(mc, function ():void {
                        (mc.getChildAt(0) as MovieClip).stop();
                    })
                }
            } else {
                Utils.callJs(jsDispatchEvent, FightEventType.ERROR, "invalid label:" + label + ", " + mc.loaderInfo.loaderURL);
                if (FighterActionType.atk().indexOf(label) >= 0) {
                    mc.gotoAndStop(FighterActionType.ATK_PHY);
                } else if (FighterActionType.hurt().indexOf(label) >= 0) {
                    mc.gotoAndStop(FighterActionType.UNDER_ATK);
                } else {
                    mc.gotoAndStop(IDLE);
                }
            }
        }

        function updateDepth(side:int, depth:int):void {
            if (side === LEFT || side === RIGHT) {
                fighters[side].depth = depth;
                petLayer.setChildIndex(fighters[side].pet, depth);
            }
        }

        function lazyApplyPet(side:int, url:String, status:String, change:Boolean, version:Object, resolve:Function):void {
            var fighter:Fighter = fighters[side];
            if (fighter.url == url) {
                updateStatus(side, status, version);
                resolve();
                return;
            }
            fighter.version += 1;
            var versionSnapshot:int = fighter.version;
            loadPet(url, function (pet:MovieClip):void {
                if (fighter.version != versionSnapshot) {
                    return;
                }

                function petDisappear():void {
                    var exist:MovieClip = fighter.pet;
                    if (exist && petLayer == exist.parent) {
                        TweenLite.to(exist, 0.5, {
                            "x": side == LEFT ? -200 : 1160,
                            "ease": Strong.easeIn,
                            "onComplete": function ():void {
                                petLayer.removeChild(exist);
                            },
                            "onCompleteParams": []
                        });
                    }
                }

                function applyPet(present:Boolean):void {
                    if (fighter.version != versionSnapshot) {
                        return;
                    }

                    petLayer.addChild(pet);
                    pet.x = fighter.x;
                    pet.y = fighter.y;
                    pet.scaleX = fighter.scaleX;
                    fighter.url = url;
                    fighter.pet = pet;

                    if (present && Utils.hasLabel(pet, FighterActionType.PRESENT)) {
                        pet.gotoAndStop(FighterActionType.PRESENT);
                        onComplete(pet, function ():void {
                            updateStatus(side, status, version);
                            resolve();
                        });
                    } else {
                        updateStatus(side, status, version);
                        resolve();
                    }
                }

                if (!change) {
                    var exist:MovieClip = fighter.pet;
                    if (exist && petLayer == exist.parent) {
                        petLayer.removeChild(exist);
                    }
                    applyPet(false);
                } else if (side === LEFT) {
                    petDisappear();
                    fightPresentMc.play();
                    setTimeout(function ():void {
                        applyPet(false);
                    }, 45 / 24 * 1000);
                } else {
                    petDisappear();
                    applyPet(true);
                }
            });
        }
    }

    private function initFighter(side:Number):Fighter {
        var fighter:Fighter = new Fighter();
        fighter.side = side;
        if (LEFT === side) {
            fighter.x = 120;
            fighter.y = 50;
            fighter.scaleX = 1;
            fighter.depth = 2;
        } else {
            fighter.x = 1200 - 120;
            fighter.y = 50;
            fighter.scaleX = -1;
            fighter.depth = 1;
        }
        fighter.version = 0;
        fighter.url = null;
        fighter.pet = null;
        fighter.status = IDLE;
        return fighter;
    }

    private function onComplete(pet:MovieClip, cb:Function):void {
        var mc:MovieClip = pet.getChildAt(0) as MovieClip;
        mc.addEventListener(Event.ENTER_FRAME, handleEnterFrame);

        function handleEnterFrame(event:Event):void {
            if (mc.currentFrame == mc.totalFrames) {
                mc.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
                cb();
            }
        }
    }

    private function loadPet(url:String, cb:Function):void {
        var exist:Class = RES_CACHE.get(url);
        if (exist) {
            cb(new exist);
        } else {
            Utils.loadSwf(url, function (domain:ApplicationDomain):void {
                var clazz:Class = domain.getDefinition("pet") as Class;
                RES_CACHE.put(url, clazz);
                cb(new clazz);
            }, function ():void {
                if (url !== DEFAULT_SWF_URL) {
                    loadPet(DEFAULT_SWF_URL, cb);
                }
            });
        }
    }
}
}
