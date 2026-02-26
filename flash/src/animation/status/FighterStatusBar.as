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
import utils.an.DisplayUtil;

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

    protected var _shape:Shape;

    private var border:MovieClip;

    public function FighterStatusBar(side:int) {
        super();
        DisplayObjectUtil.disableSprite(this);
        this.createChildren();
        var preeMc:MovieClip = this._back["preeMC"];
        if (preeMc) {
            preeMc.gotoAndStop(1);
        }
        this.layout(side);
        this.visible = false;
    }

    public function initData(pet:PetData):void {
        if (!pet) {
            this.visible = false;
            this._fighter = null;
            return;
        }
        this.visible = true;
        var old:PetData = this._fighter;
        this._fighter = pet;
        this._iconDisplayer.initData(pet.petIcon);
        if (this.border) {
            DisplayObjectUtil.removeFromParent(this.border);
        }
        this.updatePressStatus(pet.rate);
        if (this._hpSign.numChildren > 0) {
            this._hpSign.removeChildAt(0);
        }
        this._hpSign.addChild(UINumberGenerator.generateHpNumber(Math.max(pet.hp, 0), pet.maxHp));
        if (this._angerSign.numChildren > 0) {
            this._angerSign.removeChildAt(0);
        }
        this._angerSign.addChild(UINumberGenerator.generateAngerNumber(Math.max(pet.anger, 0), pet.maxAnger));
        var angerPct:Number = Math.max(pet.anger / pet.maxAnger, 0);
        var hpPct:Number = Math.max(pet.hp / pet.maxHp, 0);
        if (!old) {
            this._angerBar.initAtPercent(angerPct);
            this._healthBar.initAtPercent(hpPct);
            this._healthShadowBar.initAtPercent(hpPct);
        } else {
            this._angerBar.playToPercent(angerPct);
            this._healthBar.playToPercent(hpPct);
            this._healthShadowBar.playToPercent(hpPct);
        }
        if (this._levelSprite.numChildren > 1) {
            this._levelSprite.removeChildAt(1);
        }
        var level:Sprite = UINumberGenerator.generateFighterLevelNumber(pet.level);
        level.x = 30;
        this._levelSprite.addChild(level);
        (this._nameSprite["fighterNameTxt"] as TextField).text = pet.name;
        this._typeIcon.initData(pet.typeIcon);
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
        var preeMc:MovieClip = this._back["preeMC"];
        if (preeMc) {
            preeMc.gotoAndStop(_loc4_);
        }
    }

    protected function createChildren():void {
        this._back = new UI_FightStatusBarBack;
        addChild(this._back);
        this._shape = new Shape();
        addChild(this._shape);
        this._iconDisplayer = new PetIconDisplay();
        _iconDisplayer.setSize(72);
        addChild(this._iconDisplayer);
        this._sign = new UI_FightStatusBarSign;
        addChild(this._sign);
        this._healthShadowBar = new ShrinkBar(new UI_FightHealthShadowBar);
        addChild(this._healthShadowBar);
        this._angerBar = new AngerBar(new UI_FightAngerBar);
        addChild(this._angerBar);
        this._angerSign = new Sprite();
        addChild(this._angerSign);
        this._levelSprite = new Sprite();
        this._levelSprite.addChild(new UI_FighterLevelSign);
        addChild(this._levelSprite);
        this._nameSprite = new UI_FighterName;
        addChild(this._nameSprite);
        this._typeIcon = new IconDisplay();
        _typeIcon.setSize(16);
        addChild(this._typeIcon);
        this._healthBar = new ShrinkBar(new UI_FightHealthBar);
        addChild(this._healthBar);
        this._hpSign = new Sprite();
        addChild(this._hpSign);
    }

    protected function layout(side:int):void {
        this._healthShadowBar.visible = false;
        var setChildPosition:Function = DisplayUtil.setChildPosition;
        setChildPosition(this._iconDisplayer, 6, 7);
        setChildPosition(this._sign, 85, 9);
        setChildPosition(this._healthShadowBar, 92, 41);
        setChildPosition(this._healthBar, 111, 10);
        setChildPosition(this._hpSign, 190, 13);
        setChildPosition(this._angerBar, 110, 33);
        setChildPosition(this._angerSign, 190, 33);
        setChildPosition(this._levelSprite, 82, 53);
        setChildPosition(this._nameSprite, 4, 86);
        setChildPosition(this._typeIcon, 145, 51);
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
}
}
