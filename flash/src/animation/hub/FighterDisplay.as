package animation.hub {

import animation.common.IconDisplay;
import animation.common.PetIconDisplay;

import data.pet.PetData;

import flash.display.MovieClip;

import utils.an.DisplayObjectUtil;

[Embed(source="/_assets/battle-ui.swf", symbol="FighterDisplay")]
public dynamic class FighterDisplay extends MovieClip {
    public var back:MovieClip;
    public var typeIcon:MovieClip;

    private var _fighter:PetData;

    private var _iconDisplayer:PetIconDisplay;

    private var _typeIcon:IconDisplay;

    public function FighterDisplay() {
        this.mouseChildren = false;
        this.buttonMode = true;
        this._iconDisplayer = new PetIconDisplay();
        MovieClip(back.icon).addChild(this._iconDisplayer);
        this._iconDisplayer.setSize(55);
        this._typeIcon = new IconDisplay();
        typeIcon.addChild(this._typeIcon);
        DisplayObjectUtil.disableSprite(this._typeIcon);
        back.mark.visible = false;
        back.preeMc.gotoAndStop(1);
    }

    public function initData(fighter:PetData):void {
        _fighter = fighter;
        back.infoMc.lvTxt.text = fighter.level.toString();
        back.infoMc.hpTxt.text = Math.max(fighter.hp, 0) + "/" + fighter.maxHp;
        back.infoMc.nameTxt.text = fighter.name;
        back.healthBar.scaleX = Math.max(0, Math.min(1, fighter.hp / fighter.maxHp));
        back.mark.visible = fighter.position != 0;
        _typeIcon.initData(fighter.typeIcon);
        _iconDisplayer.initData(fighter.petIcon);
        updatePressStatus(fighter.rate);

        // 倒下的精灵显示为暗色，仍可被选作道具目标。
        if (fighter.alive <= 0) {
            DisplayObjectUtil.darkenDisplayObject(this);
        } else {
            DisplayObjectUtil.recoverDisplayObject(this);
        }
        mouseEnabled = true;
    }

    public function pet():PetData {
        return this._fighter;
    }

    public function updatePressStatus(rate:Number):void {
        back.preeMc.visible = !isNaN(rate);
        if (isNaN(rate)) return;
        var _loc4_:int = 1;
        if (rate <= 0) {
            _loc4_ = 4;
        } else if (rate < 100) {
            _loc4_ = 3;
        } else if (rate === 100) {
            _loc4_ = 1;
        } else if (rate > 100) {
            _loc4_ = 2;
        }
        back.preeMc.gotoAndStop(_loc4_);
    }
}
}
