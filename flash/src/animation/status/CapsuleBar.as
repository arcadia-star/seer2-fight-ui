package animation.status {

import data.pet.PetData;

import flash.display.Sprite;

import ui.status.UI_FightCapsuleEmpty;
import ui.status.UI_FightCapsuleOccupied;

import utils.an.DisplayObjectUtil;

internal class CapsuleBar extends Sprite {

    private static const CAPSULE_NUM:int = 6;

    private static const CAPSULE_WIDTH:int = 11;

    private var _occupiedVec:Vector.<Sprite>;

    private var _emptyVec:Vector.<Sprite>;

    public function CapsuleBar() {
        super();
        this._emptyVec = new Vector.<Sprite>();
        this.createCapsuleVec(this._emptyVec, UI_FightCapsuleEmpty);
        this._occupiedVec = new Vector.<Sprite>();
        this.createCapsuleVec(this._occupiedVec, UI_FightCapsuleOccupied);
        this.visible = false;
    }

    public function initData(param1:Vector.<PetData>):void {
        this.visible = true;
        for (var idx:int = 0; idx < CAPSULE_NUM; idx++) {
            var sprite:Sprite = this._occupiedVec[idx];
            if (idx < param1.length) {
                if (param1[idx].alive > 0) {
                    DisplayObjectUtil.recoverDisplayObject(sprite);
                } else {
                    DisplayObjectUtil.fightCapsuleBrightness(sprite);
                }
            } else {
                sprite.visible = false;
            }
        }
    }

    private function createCapsuleVec(param1:Vector.<Sprite>, clazz:Class):void {
        var _loc4_:Sprite = null;
        var _loc3_:int = 0;
        while (_loc3_ < CAPSULE_NUM) {
            (_loc4_ = new clazz).x = _loc3_ * CAPSULE_WIDTH;
            param1.push(_loc4_);
            addChild(_loc4_);
            _loc3_++;
        }
    }
}
}
