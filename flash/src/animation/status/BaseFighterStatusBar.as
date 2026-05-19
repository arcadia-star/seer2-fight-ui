package animation.status
{
import animation.common.IconDisplay;
import animation.common.PetIconDisplay;

import data.pet.FrameData;
import data.pet.PetData;

import enums.FightSide;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.text.TextField;

import ui.UINumberGenerator;
import ui.status.UI_FighterLevelSign;

import utils.an.DisplayObjectUtil;
import utils.an.DisplayUtil;

public class BaseFighterStatusBar extends MovieClip
{
    //当前显示的精灵的数据,initData()时输入
    protected var _fighter:PetData;
    //Bar的总图形,需要在子类createChildren中最先new,且必须定义
    protected var _back:Sprite;
    //头像displayer,单独模块,统一在此new,具体显示在initData中处理,缩放要在子类中调整
    protected var _iconDisplayer:IconDisplay;
    //HP 怒 的那个标签,应该都知道,Bar中自带,在此定义
    protected var _sign:MovieClip;
    //血条,Bar中自带,在此定义
    protected var _healthBar:ShrinkBar;
    //血条的虚影,Bar中自带
    protected var _healthShadowBar:ShrinkBar;
    //血量显示(数字),是单独的模块,在initData中设置显示
    protected var _hpSign:Sprite;

    protected var _angerBar:ShrinkBar;

    protected var _angerSign:Sprite;
    //等级显示,单独模块,在此new与处理
    protected var _levelSprite:Sprite;

    protected var _nameTxt:TextField;
    //属性图标,单独模块,在此new,缩放与显示在子类中调整
    protected var _typeIcon:IconDisplay;
    //头像遮罩层,Bar中自带
    protected var _iconCover:MovieClip;
    //头像背景,Bar中自带,用于显示克制关系
    protected var _preeMc:MovieClip;
    //等级的黑色背景,Bar中自带,用于辅助定位_levelSprite
    protected var _levelBg:MovieClip;
    public function BaseFighterStatusBar(side:int)
    {
        super();
        DisplayObjectUtil.disableSprite(this);
        this.createChildren();
        this.layout(side);
        this.visible = false;
    }

    protected function createChildren():void {
        //!!!调用super的该方法前必须先各自new一个_back出来!!!
        //在此创建与链接各元件,默认所有bar都包含全部元件.至于是否显示,到各自类中确定
        if(!this._back) {
            throw new Error("New BarBack first before super.createChildren()");
        }
        this._iconDisplayer = new PetIconDisplay();
        addChild(this._iconDisplayer);
        this._typeIcon = new IconDisplay();
        addChild(this._typeIcon);
        this._sign = this._back["barSign"];
        this._nameTxt = this._back["nameTxt"];
        this._preeMc = this._back["preeMC"];
        this._iconCover = this._back["cover"];
        this._levelBg = this._back["levelBg"];
        DisplayObjectUtil.removeFromParent(this._levelBg);
        this._healthBar = new ShrinkBar(this._back["healthBar"],true);
        this._angerBar = new ShrinkBar(this._back["angerBar"],true);
        this._healthShadowBar = new ShrinkBar(this._back["shadowBar"],true);
        addChild(this._healthShadowBar);
        this._hpSign = new Sprite();
        addChild(this._hpSign);
        this._angerSign = new Sprite();
        addChild(this._angerSign);
        this._levelSprite = new Sprite();
        this._levelSprite.addChild(new UI_FighterLevelSign);
        addChild(this._levelBg);
        addChild(this._levelSprite);

        this._iconDisplayer.mask = _iconCover;
        this._iconDisplayer.setSize(this._iconCover.width);
    }

    protected function layout(side:int):void {
        //该方法是调整各个元件位置,因为Bar水平翻转的时候会把文字也反向,需要在此调整文字部分翻转,并处理翻转后的位置
        //Boss的Bar逻辑和这个不一样,单独设置且不super
        DisplayUtil.setChildPosition(this._iconDisplayer, this._iconCover.x, this._iconCover.y);
        DisplayUtil.setChildPosition(this._levelSprite, this._levelBg.x + 1, this._levelBg.y + 2);
        DisplayUtil.setChildPosition(this._typeIcon,this._levelBg.x + this._levelBg.width + 1, this._levelBg.y);
        if (side == FightSide.RIGHT) {
            this._sign.scaleX *= -1;
            this._sign.x += this._sign.width;
            var targetX:int = 2 * this._levelBg.x + this._levelBg.width - this._levelSprite.x;
            this._levelSprite.scaleX *= -1;
            this._levelSprite.x = targetX;
            targetX = this._nameTxt.x + this._nameTxt.width;
            this._nameTxt.scaleX *= -1;
            this._nameTxt.x = targetX;
            this._hpSign.scaleX *= -1;
            this._angerSign.scaleX *= -1;
            this._typeIcon.scaleX *= -1;
            this._typeIcon.x += 16;
            this.scaleX = -1;
        }
    }

    public function initData(pet:PetData, smooth:int):void {
        if(!pet) {
            this.visible = false;
            this._fighter = null;
            return;
        }
        this.visible = true;
        this._fighter = pet;
        this._iconDisplayer.initData(pet.petIcon);
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
        if (smooth !== FrameData.SMOOTH_TRUE) {
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
        this._nameTxt.text = pet.name;
        this._typeIcon.initData(pet.typeIcon);
    }

    private function updatePressStatus(rate:uint):void {
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
        if (this._preeMc) {
            this._preeMc.gotoAndStop(_loc4_);
        }
    }
}
}
