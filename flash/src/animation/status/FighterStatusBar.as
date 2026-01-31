package animation.status {
import animation.common.IconDisplay;
import animation.common.PetIconDisplay;

import data.pet.PetData;

import enums.FightSide;

import flash.display.MovieClip;
import flash.display.Shape;
import flash.display.Sprite;
import flash.text.TextField;

import ui.UINumberGenerator;
import ui.status.UI_FightAngerBar;
import ui.status.UI_FightHealthBar;
import ui.status.UI_FightHealthShadowBar;
import ui.status.UI_FightStatusBarBack;
import ui.status.UI_FightStatusBarSign;
import ui.status.UI_FighterLevelSign;
import ui.status.UI_FighterName;

import utils.an.DisplayObjectUtil;

internal class FighterStatusBar extends Sprite {


    protected var _fighter:PetData;

    protected var _back:Sprite;

    protected var _iconDisplayer:IconDisplay;

    protected var _sign:Sprite;

    protected var _healthShadowBar:ShrinkBar;

    protected var _angerBar:ShrinkBar;

    protected var _angerSign:Sprite;

    protected var _levelSprite:Sprite;

    protected var _nameSprite:Sprite;

    protected var _typeIcon:IconDisplay;

    protected var _healthBar:ShrinkBar;

    protected var _hpSign:Sprite;

    protected var _preeeMC:MovieClip;

    protected var _shape:Shape;

    private var border:MovieClip;

    public function FighterStatusBar(side:int) {
        super();
        DisplayObjectUtil.disableSprite(this);
        this._back = new UI_FightStatusBarBack;
        this._preeeMC = this._back["preeMC"];
        this._preeeMC.gotoAndStop(1);
        addChild(this._back);
        this._shape = new Shape();
        addChild(this._shape);
        this._iconDisplayer = new PetIconDisplay();
        _iconDisplayer.x = 6;
        _iconDisplayer.y = 7;
        _iconDisplayer.setSize(72);
        addChild(this._iconDisplayer);
        this._sign = new UI_FightStatusBarSign;
        _sign.x = 85;
        _sign.y = 9;
        addChild(this._sign);
        this._healthShadowBar = new ShrinkBar(new UI_FightHealthShadowBar);
        _healthShadowBar.x = 92;
        _healthShadowBar.y = 41;
        this._angerBar = new AngerBar(new UI_FightAngerBar);
        _angerBar.x = 110;
        _angerBar.y = 33;
        addChild(this._angerBar);
        this._angerSign = new Sprite();
        _angerSign.x = 190;
        _angerSign.y = 33;
        addChild(this._angerSign);
        this._levelSprite = new Sprite();
        this._levelSprite.addChild(new UI_FighterLevelSign);
        _levelSprite.x = 82;
        _levelSprite.y = 53;
        addChild(this._levelSprite);
        this._nameSprite = new UI_FighterName;
        _nameSprite.x = 4;
        _nameSprite.y = 86;
        addChild(this._nameSprite);
        this._typeIcon = new IconDisplay();
        _typeIcon.x = 146;
        _typeIcon.y = 51;
        _typeIcon.setSize(16);
        addChild(this._typeIcon);
        this._healthBar = new ShrinkBar(new UI_FightHealthBar);
        _healthBar.x = 111;
        _healthBar.y = 10;
        addChild(this._healthBar);
        this._hpSign = new Sprite();
        _hpSign.x = 190;
        _hpSign.y = 13;
        addChild(this._hpSign);
        if (side === FightSide.RIGHT) {
            _sign.scaleX = -1;
            _sign.x = 107;
            _hpSign.scaleX = -1;
            _hpSign.x = 240;
            _angerSign.scaleX = -1;
            _angerSign.x = 240;
            _levelSprite.scaleX = -1;
            _levelSprite.x = 145;
            _nameSprite.scaleX = -1;
            _nameSprite.x = 78;
            _typeIcon.scaleX = -1;
            _typeIcon.x = 162;
            this.scaleX = -1;
            this.x = 1200;
        }
    }

    public function initData(param1:PetData):void {
        this._fighter = param1;
        this._iconDisplayer.initData(this._fighter.petIcon);
        if (this.border) {
            DisplayObjectUtil.removeFromParent(this.border);
        }
        var pet:PetData = this._fighter;
        this.updatePressStatus(pet.rate);
        if (this._hpSign.numChildren > 0) {
            this._hpSign.removeChildAt(0);
        }
        this._hpSign.addChild(UINumberGenerator.generateHpNumber(pet.hp, pet.maxHp));
        if (this._angerSign.numChildren > 0) {
            this._angerSign.removeChildAt(0);
        }
        this._angerSign.addChild(UINumberGenerator.generateAngerNumber(pet.anger, pet.maxAnger));
        this._angerBar.playToPercent(pet.anger / pet.maxAnger);
        var hpPct:Number = pet.hp / pet.maxHp;
        //playToPercent
        this._healthBar.initAtPercent(hpPct);
        this._healthShadowBar.initAtPercent(hpPct);
        if (this._levelSprite.numChildren > 1) {
            this._levelSprite.removeChildAt(1);
        }
        var level:Sprite = UINumberGenerator.generateFighterLevelNumber(this._fighter.level);
        level.x = 30;
        this._levelSprite.addChild(level);
        (this._nameSprite["fighterNameTxt"] as TextField).text = this._fighter.name;
        this._typeIcon.initData(this._fighter.typeIcon);
    }

    private function updatePressStatus(rate:uint):void {
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
        this._preeeMC.gotoAndStop(_loc4_);
    }
}
}
