package animation.status {
import animation.common.PetIconDisplay;

import data.pet.PetData;

import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.geom.ColorTransform;
import flash.geom.Matrix;

[Embed(source="/_assets/battle-ui.swf", symbol="NormalCapsuleBar")]
public dynamic class NormalCapsuleBar extends MovieClip {
    public var pet0:CapsuleSlot;
    public var pet1:CapsuleSlot;
    public var tip0:CapsuleTag;
    public var tip1:CapsuleTag;

    private var _backVec:Vector.<CapsuleSlot> = new Vector.<CapsuleSlot>();
    private var _tipVec:Vector.<CapsuleTag> = new Vector.<CapsuleTag>();
    private var _petIconVec:Vector.<PetIconDisplay> = new Vector.<PetIconDisplay>();

    internal function initLayout(side:String):void {
        gotoAndStop(side);
        bindSlot(pet0, tip0);
        bindSlot(pet1, tip1);
    }

    private function bindSlot(slot:CapsuleSlot, tip:CapsuleTag):void {
        tip.visible = false;
        slot.capsule.gotoAndStop(1);
        slot.back.gotoAndStop(1);
        slot.cover.gotoAndStop(1);
        bindTip(slot, tip);

        var icon:PetIconDisplay = new PetIconDisplay();
        icon.setSize(30);
        icon.mouseEnabled = icon.mouseChildren = false;
        icon.visible = false;
        slot.portrait.addChild(icon);
        _backVec.push(slot);
        _tipVec.push(tip);
        _petIconVec.push(icon);
    }

    private function appendSlot():void {
        var index:int = _backVec.length;
        var slot:CapsuleSlot = new CapsuleSlot();
        var tip:CapsuleTag = new CapsuleTag();
        slot.transform.matrix = slotMatrix(pet0, pet1, index);
        tip.transform.matrix = slotMatrix(tip0, tip1, index);
        addChildAt(tip, 0);
        addChild(slot);
        bindSlot(slot, tip);
    }

    private function slotMatrix(first:MovieClip, second:MovieClip, index:int):Matrix {
        var matrix:Matrix = first.transform.matrix;
        matrix.translate((second.x - first.x) * index, (second.y - first.y) * index);
        return matrix;
    }

    private function reveal(clip:MovieClip):void {
        if (clip.currentFrame != 1) return;
        clip.addFrameScript(clip.totalFrames - 1, clip.stop);
        clip.play();
    }

    private function bindTip(slot:CapsuleSlot, tip:CapsuleTag):void {
        slot.addEventListener(MouseEvent.MOUSE_OVER, function (event:MouseEvent):void {
            tip.visible = true;
        });
        slot.addEventListener(MouseEvent.MOUSE_OUT, function (event:MouseEvent):void {
            tip.visible = false;
        });
    }

    public function initData(pets:Vector.<PetData>):void {
        visible = true;
        while (_backVec.length < pets.length) appendSlot();
        for (var i:int = 0; i < _backVec.length; i++) {
            var slot:CapsuleSlot = _backVec[i];
            var icon:PetIconDisplay = _petIconVec[i];
            slot.visible = i < pets.length;
            if (!slot.visible) {
                icon.visible = false;
                _tipVec[i].visible = false;
                continue;
            }

            var pet:PetData = pets[i];
            var tip:CapsuleTag = _tipVec[i];
            icon.initData(pet.petIcon);
            icon.visible = !pet.ext || pet.ext.showIcon;
            if (icon.visible) {
                reveal(slot.capsule);
                reveal(slot.back);
                reveal(slot.cover);
            }
            tip.nameTxt.text = icon.visible ? pet.name : "???";
            tip.hpTxt.text = icon.visible ? pet.hp + "/" + pet.maxHp : "???/???";
            var brightness:Number = pet.alive > 0 ? 1 : 0.33;
            icon.transform.colorTransform = new ColorTransform(brightness, brightness, brightness);
        }
    }
}
}
