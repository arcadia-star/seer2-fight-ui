package animation.hub {


import animation.event.OperateEvent;

import data.pet.PetData;

import flash.display.Sprite;
import flash.events.MouseEvent;

import utils.an.DisplayObjectUtil;

internal class FighterPanel extends Sprite {

    private static const MAX_NUM_FIGHTER:int = 6;

    private var _fighterDisplayVec:Vector.<FighterDisplay>;

    private var _tip:FighterTip;

    public function FighterPanel() {
        var offsetX:int;
        var itemWidth:int;
        var i:int;
        var offsetY:int = 0;
        var onMouseOver:Function = null;
        var onMouseOut:Function = null;
        var fighterDisplay:FighterDisplay = null;
        onMouseOver = function (param1:MouseEvent):void {
            var _loc3_:PetData = null;
            var _loc2_:FighterDisplay = param1.currentTarget as FighterDisplay;
            _loc3_ = _loc2_.pet();
            _tip.x = _loc2_.x + 15;
            _tip.y = _loc2_.y;
            _tip.initData(_loc3_.skills);
            addChild(_tip);
        };
        onMouseOut = function (param1:MouseEvent):void {
            var _loc2_:FighterDisplay = param1.target as FighterDisplay;
            if (Boolean(_tip) && contains(_tip)) {
                removeChild(_tip);
            }
        };
        super();
        this.mouseEnabled = false;
        offsetX = 90;
        offsetY = 52;
        itemWidth = 116;
        this._fighterDisplayVec = new Vector.<FighterDisplay>();
        i = 0;
        while (i < MAX_NUM_FIGHTER) {
            fighterDisplay = new FighterDisplay();
            fighterDisplay.x = offsetX + itemWidth * i;
            fighterDisplay.y = offsetY;
            fighterDisplay.addEventListener(MouseEvent.CLICK, this.onMouseClick);
            fighterDisplay.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            fighterDisplay.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            this._fighterDisplayVec.push(fighterDisplay);
            addChild(fighterDisplay);
            i++;
        }
        this._tip = new FighterTip();
    }

    public function initData(param1:Vector.<PetData>):void {
        var count:Number = Math.min(param1.length, MAX_NUM_FIGHTER);
        for (var i:int = 0; i < count; i++) {
            var display:FighterDisplay = this._fighterDisplayVec[i];
            display.initData(param1[i]);
            if (!display.parent) {
                addChild(display);
            }
        }
        for (i = count; i < MAX_NUM_FIGHTER; i++) {
            display = this._fighterDisplayVec[i];
            DisplayObjectUtil.removeFromParent(display);
        }
    }

    private function onMouseClick(param1:MouseEvent):void {
        var fightDisplay:FighterDisplay = param1.currentTarget as FighterDisplay;
        dispatchEvent(OperateEvent.pet(fightDisplay.pet().pid));
    }
}
}
