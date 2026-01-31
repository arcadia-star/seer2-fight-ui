package animation.hub {

import animation.common.IconDisplay;
import animation.common.PetIconDisplay;

import data.pet.PetData;

import flash.display.MovieClip;
import flash.display.Shape;
import flash.display.Sprite;
import flash.text.TextField;

import ui.hub.UI_FightFighterMark;
import ui.hub.UI_FightPetBtn;
import ui.hub.UI_FightPetHealthBar;
import ui.hub.UI_FightPetInfo;

import utils.an.DisplayObjectUtil;

internal class FighterDisplay extends Sprite {

    private var _fighter:PetData;

    private var _backBtn:MovieClip;

    private var _iconDisplayer:PetIconDisplay;

    private var _typeIcon:IconDisplay;

    private var _healthBar:Sprite;

    private var _infoDisplay:MovieClip;

    private var _lvTxt:TextField;

    private var _hpTxt:TextField;

    private var _nameTxt:TextField;

    private var _mark:MovieClip;

    private var _shape:Shape;

    public function FighterDisplay() {
        super();
        this.mouseChildren = false;
        this.buttonMode = true;
        this._backBtn = new UI_FightPetBtn;
        this._backBtn.gotoAndStop(1);
        addChild(this._backBtn);
        this._shape = new Shape();
        this._shape.x = 45;
        this._shape.y = 43;
        addChild(this._shape);
        this._iconDisplayer = new PetIconDisplay();
        this._iconDisplayer.x = 20;
        this._iconDisplayer.y = 10;
        this._iconDisplayer.setSize(54);
        DisplayObjectUtil.disableSprite(this._iconDisplayer);
        addChild(this._iconDisplayer);
        this._healthBar = new UI_FightPetHealthBar;
        this._healthBar.x = 12;
        this._healthBar.y = 63;
        addChild(this._healthBar);
        this._infoDisplay = new UI_FightPetInfo;
        DisplayObjectUtil.disableSprite(this._infoDisplay);
        this._infoDisplay.x = -15;
        this._infoDisplay.y = 10;
        this._lvTxt = this._infoDisplay["lvTxt"];
        this._hpTxt = this._infoDisplay["hpTxt"];
        this._nameTxt = this._infoDisplay["nameTxt"];
        addChild(this._infoDisplay);
        this._typeIcon = new IconDisplay();
        this._typeIcon.x = 75;
        DisplayObjectUtil.disableSprite(this._typeIcon);
        addChild(this._typeIcon);
        this._mark = new UI_FightFighterMark;
        this._mark.visible = false;
        addChild(this._mark);
    }

    public function initData(param1:PetData):void {
        this._fighter = param1;
        this.showFighter();
    }

    public function pet():PetData {
        return this._fighter;
    }

    public function updatePressStatus(rate:uint):void {
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
        this._backBtn.gotoAndStop(_loc4_);
    }

    private function showFighter():void {
        this.updateInteraction();
        this.updateInfoDisplay();
        this.updateHealthBar();
        this._typeIcon.initData(this._fighter.typeIcon);
        this._iconDisplayer.initData(this._fighter.petIcon);
        this.updateFightingMark();
        updatePressStatus(this._fighter.rate);
    }

    private function updateInteraction():void {
        if (this._fighter.hp <= 0) {
            this.mouseEnabled = false;
            DisplayObjectUtil.darkenDisplayObject(this);
        } else {
            this.mouseEnabled = true;
            DisplayObjectUtil.recoverDisplayObject(this);
        }
        if (this._fighter.position != 0) {
            this.mouseEnabled = false;
        }
    }

    private function updateInfoDisplay():void {
        var _loc1_:PetData = this._fighter;
        this._lvTxt.text = _loc1_.level.toString();
        this._hpTxt.text = _loc1_.hp + "/" + _loc1_.maxHp;
        this._nameTxt.text = _loc1_.name;
    }

    private function updateHealthBar():void {
        var _loc1_:PetData = this._fighter;
        var _loc2_:Number = _loc1_.hp / _loc1_.maxHp;
        if (_loc2_ > 1) {
            _loc2_ = 1;
        }
        this._healthBar.scaleX = _loc2_;
    }

    private function updateFightingMark():void {
        if (this._fighter.position != 0) {
            this._mark.visible = true;
        } else {
            this._mark.visible = false;
        }
    }

    private function enabled(param1:Boolean):void {
        if (param1) {
            this._infoDisplay.visible = true;
            this._healthBar.visible = true;
            this._typeIcon.visible = true;
            this.mouseEnabled = true;
        } else {
            this._infoDisplay.visible = false;
            this._healthBar.visible = false;
            this._typeIcon.visible = false;
            this.mouseEnabled = false;
        }
    }
}
}
