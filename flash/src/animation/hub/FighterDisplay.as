package animation.hub {

import animation.common.IconDisplay;
import animation.common.PetIconDisplay;

import data.pet.PetData;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.text.TextField;

import utils.an.DisplayObjectUtil;

internal class FighterDisplay {

    private var _view:MovieClip;

    public function get view():MovieClip { return _view; }

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

    private var _preeMc:MovieClip;


    public function FighterDisplay(view:MovieClip) {
        this._view = view;
        this._view.mouseChildren = false;
        this._view.buttonMode = true;
        this._backBtn = _view.getChildByName("back") as MovieClip;
        this._iconDisplayer = new PetIconDisplay();
        MovieClip(this._backBtn["icon"]).addChild(this._iconDisplayer);
        this._iconDisplayer.setSize(55);
        this._healthBar = this._backBtn["healthBar"];
        this._infoDisplay = this._backBtn["infoMc"];
        this._lvTxt = this._infoDisplay["lvTxt"];
        this._hpTxt = this._infoDisplay["hpTxt"];
        this._nameTxt = this._infoDisplay["nameTxt"];
        this._typeIcon = new IconDisplay();
        MovieClip(_view["typeIcon"]).addChild(this._typeIcon);
        DisplayObjectUtil.disableSprite(this._typeIcon);
        this._mark = this._backBtn["mark"];
        this._mark.visible = false;
        this._preeMc = this._backBtn["preeMc"];
        this._preeMc.gotoAndStop(1);
    }

    public function initData(param1:PetData):void {
        this._fighter = param1;
        this.showFighter();
    }

    public function pet():PetData {
        return this._fighter;
    }

    public function updatePressStatus(rate:Number):void {
        this._preeMc.visible = !isNaN(rate);
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
        this._preeMc.gotoAndStop(_loc4_);
    }

    private function showFighter():void {
        this.updateInteraction();
        this.updateInfoDisplay();
        this.updateHealthBar();
        this._typeIcon.initData(this._fighter.typeIcon);
        this._iconDisplayer.initData(this._fighter.petIcon);
        this.updateFightingMark();
        this.updatePressStatus(this._fighter.rate);
    }

    private function updateInteraction():void {
        if (this._fighter.alive <= 0) {
            this._view.mouseEnabled = false;
            DisplayObjectUtil.darkenDisplayObject(this._view);
        } else {
            this._view.mouseEnabled = true;
            DisplayObjectUtil.recoverDisplayObject(this._view);
        }
        if (this._fighter.position != 0) {
            this._view.mouseEnabled = false;
        }
        //都放开点击，让调用方自己控制
        this._view.mouseEnabled = true;
    }

    private function updateInfoDisplay():void {
        var _loc1_:PetData = this._fighter;
        this._lvTxt.text = _loc1_.level.toString();
        this._hpTxt.text = Math.max(_loc1_.hp, 0) + "/" + _loc1_.maxHp;
        this._nameTxt.text = _loc1_.name;
    }

    private function updateHealthBar():void {
        var _loc1_:PetData = this._fighter;
        var _loc2_:Number = _loc1_.hp / _loc1_.maxHp;
        if (_loc2_ > 1) {
            _loc2_ = 1;
        }
        if (_loc2_ < 0) {
            _loc2_ = 0;
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
            this._view["typeIcon"].visible = true;
            this._view.mouseEnabled = true;
        } else {
            this._infoDisplay.visible = false;
            this._healthBar.visible = false;
            this._view["typeIcon"].visible = false;
            this._view.mouseEnabled = false;
        }
    }
}
}
