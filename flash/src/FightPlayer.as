package {
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.external.ExternalInterface;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.text.TextField;

[SWF(width="1200", height="660", frameRate="30")]
public class FightPlayer extends Sprite {
    public static const WINDOW_WIDTH:int = 1200;
    public static const HIT_EVENT:String = "hit";
    public static const PET:String = "pet";
    public static const IDLE:String = FighterActionType.IDLE;
    public static const DEFAULT_JS_DISPATCH:String = "flash_dispatch";
    public static const DEFAULT_SWF_URL:String = "http://seer2.61.com/res/pet/fight/6.swf";
    public static const AS_PLAY_FIGHT:String = "flash_playFight";
    private static const LEFT:int = 1;
    private static const RIGHT:int = 2;

    public function FightPlayer() {
        var params:Object = LoaderInfo(this.root.loaderInfo).parameters;
        var jsDispatchEvent:String = params["cb"] || DEFAULT_JS_DISPATCH;
        var leftUrl:String = params["url"] || DEFAULT_SWF_URL;
        var rightUrl:String = params["url2"] || DEFAULT_SWF_URL;

        var status:Array = [null, IDLE, IDLE];
        var pets:Array = [null, null, null];
        var depthes:Array = [null, 1, 2];

        loadPet(leftUrl, function (left:MovieClip):void {
            pets[LEFT] = left;
            addChild(left);
            left.x = 120;
            left.y = 50;
            updateStatus(LEFT, IDLE);
            tryPlayFight();
        });
        loadPet(rightUrl, function (right:MovieClip):void {
            pets[RIGHT] = right;
            addChild(right);
            right.scaleX = -1;
            right.x = WINDOW_WIDTH - 120;
            right.y = 50;
            updateStatus(RIGHT, IDLE);
            tryPlayFight();
        });

        function tryPlayFight():void {
            var left:MovieClip = pets[LEFT];
            var right:MovieClip = pets[RIGHT];
            if (!right || !left) {
                return;
            }

            callJs(jsDispatchEvent, FightEventType.INIT, {left: leftUrl, right: rightUrl});
            addCallbackJs(AS_PLAY_FIGHT, playFight);
        }

        function playFight(moveSide:int = LEFT,
                           moveLabel:String = FighterActionType.ATK_PHY,
                           hitLabel:String = FighterActionType.UNDER_ATK,
                           atkLabel:String = IDLE,
                           defLabel:String = IDLE):void {
            callJs(jsDispatchEvent, FightEventType.PLAY, {
                moveSide: moveSide,
                moveLabel: moveLabel,
                hitLabel: hitLabel,
                atkLabel: atkLabel,
                defLabel: defLabel
            });
            var atkSide:int = moveSide == LEFT ? LEFT : RIGHT;
            var defSide:int = atkSide == RIGHT ? LEFT : RIGHT;

            var atk:MovieClip = pets[atkSide];
            var def:MovieClip = pets[defSide];

            updateDepth(defSide, 1);
            updateDepth(atkSide, 2);

            safeGotoAndStop(atk, moveLabel);
            callJs(jsDispatchEvent, FightEventType.MOVE_START);
            onComplete(atk, function ():void {
                updateStatus(atkSide, atkLabel);
                callJs(jsDispatchEvent, FightEventType.MOVE_END);
            })
            once(atk, HIT_EVENT, function ():void {
                safeGotoAndStop(def, hitLabel);
                callJs(jsDispatchEvent, FightEventType.HIT);
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
                trace("Error: invalid label:" + label);
                mc.gotoAndStop(IDLE);
            }
        }

        function updateStatus(side:int, label:String):void {
            if (side === LEFT || side === RIGHT) {
                status[side] = label;
                safeGotoAndStop(pets[side], label);
            }
        }

        function updateDepth(side:int, depth:int):void {
            if (side === LEFT || side === RIGHT) {
                depthes[side] = depth;
                setChildIndex(pets[side], depth);
            }
        }

        {
            var logText:TextField = new TextField();
            logText.textColor = 0x000000;
            logText.width = 300;
            addChild(logText);

            function updateSize():void {
                logText.text = "size: " + stage.stageWidth + " x " + stage.stageHeight + "," + width + " x " + height
                        + "\nleft: " + leftUrl
                        + "\nright: " + rightUrl;
            }

            stage.addEventListener(Event.RESIZE, function (e:Event):void {
                updateSize();
            });

            updateSize();
        }
    }

    private function once(dispatcher:IEventDispatcher, name:String, cb:Function):void {
        dispatcher.addEventListener(name, handleOnce);

        function handleOnce(event:Event):void {
            dispatcher.removeEventListener(name, handleOnce);
            cb();
        }
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
        loadSwf(url, function (domain:ApplicationDomain):void {
            cb(new (domain.getDefinition(PET) as Class));
        });
    }

    private function loadSwf(url:String, cb:Function):void {
        var loader:Loader = new Loader();
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function (event:Event):void {
            cb(loader.contentLoaderInfo.applicationDomain)
        });
        loader.load(new URLRequest(url));
    }

    private function callJs(func:String, event:String, data:Object = null):void {
        if (ExternalInterface.available) {
            ExternalInterface.call(func, {func: func, event: event, data: data});
        }
    }

    private function addCallbackJs(functionName:String, closure:Function):void {
        if (ExternalInterface.available) {
            ExternalInterface.addCallback(functionName, closure);
        }
    }
}
}
