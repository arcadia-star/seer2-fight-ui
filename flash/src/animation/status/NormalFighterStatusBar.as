package animation.status {
import animation.common.IconDisplay;
import animation.common.PetIconDisplay;
import animation.status.skins.FighterLevelSkin;

import data.pet.FrameData;
import data.pet.PetData;

import flash.display.MovieClip;

import ui.UINumberGenerator;

import utils.an.DisplayObjectUtil;

public dynamic class NormalFighterStatusBar extends MovieClip {
    public var back:MovieClip;
    public var portrait:MovieClip;
    public var portraitMask:MovieClip;
    public var typeIcon:MovieClip;
    public var typeIconScale:MovieClip;
    public var hpValue:MovieClip;
    public var angerValue:MovieClip;
    public var level:FighterLevelSkin;

    private var _fighter:PetData;
    private var _iconDisplayer:IconDisplay = new PetIconDisplay();
    private var _typeIcon:IconDisplay = new IconDisplay();
    private var _healthBar:ShrinkBar;
    private var _healthShadowBar:ShrinkBar;
    private var _angerBar:ShrinkBar;

    public function NormalFighterStatusBar() {
        DisplayObjectUtil.disableSprite(this);
        portrait.addChild(_iconDisplayer);
        _iconDisplayer.setSize(portraitMask.width);
        typeIcon.addChild(_typeIcon);
        _typeIcon.setScale(typeIconScale.scaleX, typeIconScale.scaleY);
        _healthBar = new ShrinkBar(back.healthBar, true);
        _healthShadowBar = new ShrinkBar(back.shadowBar, true);
        _angerBar = new ShrinkBar(back.angerBar, true);
    }

    public function initData(pet:PetData, smooth:int):void {
        if (!pet) {
            visible = false;
            this._fighter = null;
            return;
        }
        visible = true;
        this._fighter = pet;
        this._iconDisplayer.initData(pet.petIcon);
        this.updatePressStatus(pet.rate);
        if (hpValue.numChildren > 0) {
            hpValue.removeChildAt(0);
        }
        hpValue.addChild(UINumberGenerator.generateHpNumber(Math.max(pet.hp, 0), pet.maxHp));
        this.updateAnger(pet.anger, smooth);
        var hpPct:Number = Math.max(pet.hp / pet.maxHp, 0);
        if (smooth !== FrameData.SMOOTH_TRUE) {
            this._healthBar.initAtPercent(hpPct);
            this._healthShadowBar.initAtPercent(hpPct);
        } else {
            this._healthBar.playToPercent(hpPct);
            this._healthShadowBar.playToPercent(hpPct);
        }
        if (level.value.numChildren > 0) {
            level.value.removeChildAt(0);
        }
        level.value.addChild(UINumberGenerator.generateFighterLevelNumber(pet.level));
        back.nameTxt.text = pet.name;
        this._typeIcon.initData(pet.typeIcon);
    }

    public function playAnger(before:int, after:int):void {
        this._angerBar.initAtPercent(Math.max(before / this._fighter.maxAnger, 0));
        this.updateAnger(after, FrameData.SMOOTH_TRUE);
    }

    private function updateAnger(value:int, smooth:int):void {
        if (angerValue.numChildren > 0) {
            angerValue.removeChildAt(0);
        }
        angerValue.addChild(UINumberGenerator.generateAngerNumber(Math.max(value, 0), this._fighter.maxAnger));
        var percent:Number = Math.max(value / this._fighter.maxAnger, 0);
        if (smooth === FrameData.SMOOTH_TRUE) {
            this._angerBar.playToPercent(percent);
        } else {
            this._angerBar.initAtPercent(percent);
        }
    }

    public function whenSettled(done:Function):void {
        // 血条和残影随动作播放，不阻塞下一帧。
        this._angerBar.whenSettled(done);
    }

    private function updatePressStatus(rate:Number):void {
        back.preeMC.visible = !isNaN(rate);
        if (isNaN(rate)) return;
        //调整preeMc,显示克制关系,1帧是普通,2帧是克制,3帧是微弱,4帧是无效
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
        back.preeMC.gotoAndStop(_loc4_);
    }
}
}
