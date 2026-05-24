package animation.status {
import animation.common.IconDisplay;
import animation.common.NumDisplay;
import animation.common.TipsDisplay;

import data.pet.BuffData;

import flash.display.Sprite;

import utils.an.DisplayObjectUtil;

internal class BuffIcon extends Sprite {
    private static const ICON_WIDTH:int = 32;

    private var _buff:BuffData;

    private var _icon:IconDisplay;
    private var _tips:TipsDisplay;

    private var _numDisplay:NumDisplay;
    private var _showNumMin:int;
    private var _lastIcon:String = null;
    private var _lastTips:String = null;
    private var _lastCount:int = int.MIN_VALUE;
    private var _lastShowNum:Boolean = false;

    public function BuffIcon() {
        super();
        var sprite:Sprite = new Sprite();
        this._icon = new IconDisplay;
        _icon.setSize(ICON_WIDTH);
        sprite.addChild(this._icon);
        this._numDisplay = new NumDisplay();
        _numDisplay.x = 0;
        _numDisplay.y = 15;
        _numDisplay.visible = false;
        this._showNumMin = 2;
        sprite.addChild(this._numDisplay);
        this._tips = new TipsDisplay(sprite);
        addChild(this._tips);
        DisplayObjectUtil.disableSprite(_numDisplay);
    }

    public function initData(buff:BuffData):void {
        this._buff = buff;
        if (this._lastIcon !== buff.icon) {
            this._icon.initData(buff.icon);
            this._lastIcon = buff.icon;
        }
        var tips:String = buff.tips || "无";
        if (this._lastTips !== tips) {
            this._tips.initData(tips);
            this._lastTips = tips;
        }
        var showNum:Boolean = buff.count >= _showNumMin;
        if (showNum && this._lastCount !== buff.count) {
            this._numDisplay.initData(buff.count);
            this._lastCount = buff.count;
        }
        if (this._lastShowNum !== showNum) {
            this._numDisplay.visible = showNum;
            this._lastShowNum = showNum;
        }
    }

    public function setShowNumMin(showNumMin:int):void {
        if (this._showNumMin === showNumMin) {
            return;
        }
        this._showNumMin = showNumMin;
        this._lastShowNum = !this._lastShowNum;
    }
}
}
