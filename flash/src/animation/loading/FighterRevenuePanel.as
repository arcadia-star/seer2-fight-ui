package animation.loading {
import enums.FightSide;

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

import ui.end.FightKOAnimation;
import ui.end.FightResultBack;
import ui.end.FightResultBtn;
import ui.end.FightResultFlag;
import ui.end.QuickUpBtn;

import utils.an.DisplayObjectUtil;

public class FighterRevenuePanel extends Sprite {
    private var _back:Sprite;

    private var _resultFlag:MovieClip;

    private var _koAnimation:MovieClip;

    private var _revenueUnitHolder:Sprite;

    private var _btn:SimpleButton;

    private var _shopBtn:SimpleButton;

    public function FighterRevenuePanel() {
        this._back = new FightResultBack();
        addChild(this._back);
        DisplayObjectUtil.disableSprite(this._back);
        this._resultFlag = new FightResultFlag();
        this._resultFlag.gotoAndStop(1);
        this._resultFlag.visible = false;
        this._resultFlag.y = 16;
        addChild(this._resultFlag);
        DisplayObjectUtil.disableSprite(this._resultFlag);
        this._revenueUnitHolder = new Sprite();
        this._revenueUnitHolder.visible = false;
        addChild(this._revenueUnitHolder);
        this._btn = new FightResultBtn();
        this._btn.x = 380;
        this._btn.y = 281;
        this._btn.visible = false;
        addChild(this._btn);
        this._shopBtn = new QuickUpBtn();
        this._shopBtn.x = this._btn.x + this._btn.width + 40;
        this._shopBtn.y = this._btn.y;
        this._shopBtn.visible = false;
        addChild(this._shopBtn);
        this._btn.addEventListener(MouseEvent.CLICK, this.onBtnClick);
        this._shopBtn.addEventListener(MouseEvent.CLICK, this.onBtnClick);
        this._koAnimation = new FightKOAnimation();
        this._revenueUnitHolder.addChild(_koAnimation);
        this._resultFlag.x = 142;
        this._resultFlag.visible = true;
        var rect:Rectangle = new Rectangle(55, 54, 860, 230);
        this._revenueUnitHolder.x = rect.x + (rect.width - this._revenueUnitHolder.width >> 1);
        this._revenueUnitHolder.y = rect.y + (rect.height - this._revenueUnitHolder.height >> 1);
        this._revenueUnitHolder.visible = true;
        this._btn.visible = true;
        this._shopBtn.visible = true;
        this.x = 120;
        this.y = 171;
        this.alpha = 1
    }

    private function onBtnClick(evt:MouseEvent):void {
        evt.stopImmediatePropagation();
        dispatchEvent(new Event(Event.CLOSE));
    }

    public function initData(side:int):void {
        if (side === FightSide.LEFT) {
            this._resultFlag.gotoAndStop(1);
            this._koAnimation.visible = true;
        } else {
            this._resultFlag.gotoAndStop(2);
            this._koAnimation.visible = false;
        }
    }
}
}

