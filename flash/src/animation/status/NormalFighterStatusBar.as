package animation.status {
import animation.common.IconDisplay;
import animation.common.PetIconDisplay;
import data.pet.FrameData;
import data.pet.PetData;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.text.TextField;
import ui.UINumberGenerator;
import utils.an.DisplayObjectUtil;

internal class NormalFighterStatusBar {
    private var _view:MovieClip;
    private var _fighter:PetData;
    private var _back:MovieClip;
    private var _iconDisplayer:IconDisplay=new PetIconDisplay();
    private var _typeIcon:IconDisplay=new IconDisplay();
    private var _healthBar:ShrinkBar;
    private var _healthShadowBar:ShrinkBar;
    private var _angerBar:ShrinkBar;
    private var _hpSign:Sprite;
    private var _angerSign:Sprite;
    private var _levelSprite:Sprite;
    private var _nameTxt:TextField;
    private var _preeMc:MovieClip;
    public function NormalFighterStatusBar(view:MovieClip) {
        _view=view;
        DisplayObjectUtil.disableSprite(view);
        _back=view["back"];
        view["portrait"].addChild(_iconDisplayer);
        _iconDisplayer.setSize(view["portraitMask"].width);
        view["typeIcon"].addChild(_typeIcon);
        _typeIcon.setScale(view["typeIconScale"].scaleX,view["typeIconScale"].scaleY);
        _healthBar=new ShrinkBar(_back["healthBar"],true);
        _healthShadowBar=new ShrinkBar(_back["shadowBar"],true);
        _angerBar=new ShrinkBar(_back["angerBar"],true);
        _hpSign=view["hpValue"];
        _angerSign=view["angerValue"];
        _levelSprite=view["level"]["value"];
        _nameTxt=_back["nameTxt"];
        _preeMc=_back["preeMC"];
    }
    public function initData(pet:PetData, smooth:int):void {
        if(!pet) {
            this._view.visible = false;
            this._fighter = null;
            return;
        }
        this._view.visible = true;
        this._fighter = pet;
        this._iconDisplayer.initData(pet.petIcon);
        this.updatePressStatus(pet.rate);
        if (this._hpSign.numChildren > 0) {
            this._hpSign.removeChildAt(0);
        }
        this._hpSign.addChild(UINumberGenerator.generateHpNumber(Math.max(pet.hp, 0), pet.maxHp));
        this.updateAnger(pet.anger, smooth);
        var hpPct:Number = Math.max(pet.hp / pet.maxHp, 0);
        if (smooth !== FrameData.SMOOTH_TRUE) {
            this._healthBar.initAtPercent(hpPct);
            this._healthShadowBar.initAtPercent(hpPct);
        } else {
            this._healthBar.playToPercent(hpPct);
            this._healthShadowBar.playToPercent(hpPct);
        }
        if (this._levelSprite.numChildren > 0) {
            this._levelSprite.removeChildAt(0);
        }
        var level:Sprite = UINumberGenerator.generateFighterLevelNumber(pet.level);
        this._levelSprite.addChild(level);
        this._nameTxt.text = pet.name;
        this._typeIcon.initData(pet.typeIcon);
    }

    public function playAnger(before:int, after:int):void {
        this._angerBar.initAtPercent(Math.max(before / this._fighter.maxAnger, 0));
        this.updateAnger(after, FrameData.SMOOTH_TRUE);
    }

    private function updateAnger(value:int, smooth:int):void {
        if (this._angerSign.numChildren > 0) {
            this._angerSign.removeChildAt(0);
        }
        this._angerSign.addChild(UINumberGenerator.generateAngerNumber(Math.max(value, 0), this._fighter.maxAnger));
        var percent:Number = Math.max(value / this._fighter.maxAnger, 0);
        if (smooth === FrameData.SMOOTH_TRUE) {
            this._angerBar.playToPercent(percent);
        } else {
            this._angerBar.initAtPercent(percent);
        }
    }

    public function whenSettled(done:Function):void {
        var remaining:int = 3;
        function complete():void {
            remaining--;
            if (remaining === 0) done();
        }
        this._angerBar.whenSettled(complete);
        this._healthBar.whenSettled(complete);
        this._healthShadowBar.whenSettled(complete);
    }

    private function updatePressStatus(rate:Number):void {
        this._preeMc.visible = !isNaN(rate);
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
        this._preeMc.gotoAndStop(_loc4_);
    }
}
}
