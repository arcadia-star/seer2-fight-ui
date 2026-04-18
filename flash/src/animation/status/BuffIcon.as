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
        this._icon.initData(buff.icon)
        this._tips.initData(buff.tips || '无');
        if (buff.count >= _showNumMin) {
            this._numDisplay.initData(buff.count);
            this._numDisplay.visible = true;
        } else {
            this._numDisplay.visible = false;
        }
    }

    public function setShowNumMin(showNumMin:int):void {
        this._showNumMin = showNumMin;
    }
}
}
