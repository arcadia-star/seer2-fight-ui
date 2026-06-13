package animation.ext {
import enums.FighterActionType;

import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.events.Event;

import ui.PetFallback;

import utils.Utils;

public class S1Pet extends MovieClip {
    private var _origin:MovieClip;

    public function S1Pet(origin:MovieClip) {
        this._origin = origin;
        _origin.x = 180;
        _origin.y = 250;
        addChild(_origin);

        gotoAndStop(FighterActionType.IDLE);

        addChild(PetFallback.showPetFrames(_origin));
    }

    override public function get currentLabels():Array {
        return [
            {'name': FighterActionType.ATK_PHY},
            {'name': FighterActionType.ATK_SPE},
            {'name': FighterActionType.ATK_BUF},
            {'name': FighterActionType.UNDER_ATK},
            {'name': FighterActionType.IDLE}
        ]
    }

    override public function getChildAt(index:int):DisplayObject {
        return _origin.getChildAt(index);
    }

    override public function gotoAndStop(frame:Object, scene:String = null):void {
        //todo version
        var label:String;
        if (frame === FighterActionType.ATK_PHY) {
            label = "attack";
        } else if (frame === FighterActionType.ATK_SPE) {
            label = "sa";
        } else if (frame === FighterActionType.ATK_BUF) {
            label = "cp";
        } else if (frame === FighterActionType.UNDER_ATK) {
            label = "hited";
        } else {
            label = "attack";
        }
        Utils.gotoAndStop(_origin, label, function ():void {
            var child0:MovieClip = _origin.getChildAt(0) as MovieClip;

            if (frame === FighterActionType.IDLE) {
                child0.gotoAndStop(0);
            } else {
                child0.gotoAndPlay(1);
                child0.addEventListener(Event.ENTER_FRAME, handleEnterFrame1);

                function handleEnterFrame1(event:Event):void {
                    if (child0.hit) {
                        child0.hit = false;
                        dispatchEvent(new Event("hit"));
                    }
                    if (child0.currentFrame == child0.totalFrames) {
                        child0.removeEventListener(Event.ENTER_FRAME, handleEnterFrame1);
                        child0.gotoAndStop(0);
                    }
                }
            }
        });
    }
}
}
