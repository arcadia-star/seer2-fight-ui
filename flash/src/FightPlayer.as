package {
import flash.display.LoaderInfo;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.system.ApplicationDomain;
import flash.text.TextField;

[SWF(width="1200", height="660", frameRate="30")]
public class FightPlayer extends Sprite {
    public static const WINDOW_WIDTH:int = 1200;
    public static const HIT_EVENT:String = "hit";
    public static const PET:String = "pet";
    public static const IDLE:String = FighterActionType.IDLE;
    public static const DEFAULT_JS_DISPATCH:String = "flash_dispatch";
    public static const DEFAULT_SWF_URL:String = "http://seer2.61.com/res/pet/fight/4.swf";
    public static const AS_PLAY_FIGHT:String = "flash_playFight";
    private static const LEFT:int = 1;
    private static const RIGHT:int = 2;
    private static const RES_MAP:Object = {};

    public function FightPlayer() {
        var params:Object = LoaderInfo(this.root.loaderInfo).parameters;
        var jsDispatchEvent:String = params["cb"] || DEFAULT_JS_DISPATCH;
        var leftUrl:String = params["url"] || DEFAULT_SWF_URL;
        var rightUrl:String = params["url2"] || DEFAULT_SWF_URL;

        var fighters:Vector.<Fighter> = Vector.<Fighter>([null, initFighter(LEFT, leftUrl), initFighter(RIGHT, rightUrl)]);

        loadPet(leftUrl, function (left:MovieClip):void {
            applyPet(LEFT, left);
            tryPlayFight();
        });
        loadPet(rightUrl, function (right:MovieClip):void {
            applyPet(RIGHT, right);
            tryPlayFight();
        });

        function tryPlayFight():void {
            var left:MovieClip = fighters[LEFT].pet;
            var right:MovieClip = fighters[RIGHT].pet;
            if (!right || !left) {
                return;
            }

            Utils.addCallbackJs(AS_PLAY_FIGHT, playFight);
            Utils.callJs(jsDispatchEvent, FightEventType.INIT, {left: leftUrl, right: rightUrl});
        }

        function playFight(moveSide:int = LEFT,
                           moveLabel:String = FighterActionType.ATK_PHY,
                           hitLabel:String = FighterActionType.UNDER_ATK,
                           atkLabel:String = IDLE,
                           defLabel:String = IDLE):void {
            Utils.callJs(jsDispatchEvent, FightEventType.PLAY, {
                moveSide: moveSide,
                moveLabel: moveLabel,
                hitLabel: hitLabel,
                atkLabel: atkLabel,
                defLabel: defLabel
            });
            var atkSide:int = moveSide == LEFT ? LEFT : RIGHT;
            var defSide:int = atkSide == RIGHT ? LEFT : RIGHT;

            var atk:MovieClip = fighters[atkSide].pet;
            var def:MovieClip = fighters[defSide].pet;

            updateDepth(defSide, 1);
            updateDepth(atkSide, 2);

            safeGotoAndStop(atk, moveLabel);
            Utils.callJs(jsDispatchEvent, FightEventType.MOVE_START);
            onComplete(atk, function ():void {
                updateStatus(atkSide, atkLabel);
                Utils.callJs(jsDispatchEvent, FightEventType.MOVE_END);
            })
            Utils.once(atk, HIT_EVENT, function ():void {
                safeGotoAndStop(def, hitLabel);
                Utils.callJs(jsDispatchEvent, FightEventType.HIT);
                onComplete(def, function ():void {
                    updateStatus(defSide, defLabel);
                })
            });
        }

        function safeGotoAndStop(mc:MovieClip, label:String):void {
            var valid:Boolean = mc.currentLabels.some(function (e:Object, index:int, array:Array):Boolean {
                return e.name == label;
            });
            if (valid) {
                mc.gotoAndStop(label);
            } else {
                Utils.callJs(jsDispatchEvent, FightEventType.ERROR, "Error: invalid label:" + label);
                if (FighterActionType.atk().indexOf(label) >= 0) {
                    mc.gotoAndStop(FighterActionType.ATK_PHY);
                } else {
                    mc.gotoAndStop(IDLE);
                }
            }
        }

        function updateStatus(side:int, label:String):void {
            if (side === LEFT || side === RIGHT) {
                fighters[side].status = label;
                safeGotoAndStop(fighters[side].pet, label);
            }
        }

        function updateDepth(side:int, depth:int):void {
            if (side === LEFT || side === RIGHT) {
                fighters[side].depth = depth;
                setChildIndex(fighters[side].pet, depth);
            }
        }

        function applyPet(side:int, pet:MovieClip):void {
            var fighter:Fighter = fighters[side];
            var exist:MovieClip = fighter.pet;
            if (exist) {
                removeChild(exist);
            }
            fighter.pet = pet;
            addChild(pet);
            pet.x = fighter.x;
            pet.y = fighter.y;
            pet.scaleX = fighter.scaleX;
            setChildIndex(pet, fighter.depth);
            safeGotoAndStop(pet, fighter.status);
        }

        {
            var logText:TextField = new TextField();
            logText.textColor = 0x000000;
            logText.width = 600;
            addChild(logText);

            function updateSize():void {
                logText.text = "debug info:"
                        + "\nloader:" + root.loaderInfo.loaderURL
                        + "\nsize: " + stage.stageWidth + "x" + stage.stageHeight + ", " + width + "x" + height
                        + "\nleft: " + leftUrl
                        + "\nright: " + rightUrl;
            }

            stage.addEventListener(Event.RESIZE, function (e:Event):void {
                updateSize();
            });

            updateSize();
        }
    }

    private function initFighter(side:Number, url:String):Fighter {
        var fighter:Fighter = new Fighter();
        fighter.side = side;
        fighter.url = url;
        fighter.fallback = true;
        if (LEFT === side) {
            fighter.x = 120;
            fighter.y = 50;
            fighter.scaleX = 1;
            fighter.depth = 2;
        } else {
            fighter.x = WINDOW_WIDTH - 120;
            fighter.y = 50;
            fighter.scaleX = -1;
            fighter.depth = 1;
        }
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
        var exist:Class = RES_MAP[url];
        if (exist) {
            cb(new exist);
        } else {
            Utils.loadSwf(url, function (domain:ApplicationDomain):void {
                var clazz:Class = domain.getDefinition(PET) as Class;
                RES_MAP[url] = clazz;
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
