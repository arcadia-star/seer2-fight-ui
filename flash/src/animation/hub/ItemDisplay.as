package animation.hub {

import animation.common.IconDisplay;

import data.pet.ItemData;

import flash.display.MovieClip;
import flash.display.Sprite;

import ui.UINumberGenerator;

import utils.an.DisplayObjectUtil;

[Embed(source="/_assets/battle-ui.swf", symbol="ItemDisplay")]
public dynamic class ItemDisplay extends MovieClip {
    public var icon:MovieClip;
    public var count:MovieClip;

    private var _info:ItemData;

    private var _iconDisplay:IconDisplay;

    private var _numSprite:Sprite;

    public function ItemDisplay() {
        this.mouseChildren = false;
        this.buttonMode = true;
        this._iconDisplay = new IconDisplay();
        icon.addChild(this._iconDisplay);
        _iconDisplay.setSize(60);
        DisplayObjectUtil.disableSprite(this._iconDisplay);
        DisplayObjectUtil.disableSprite(this);
    }

    public function initData(param1:ItemData):void {
        if (_info === param1) {
            return;
        }
        if (!param1) {
            DisplayObjectUtil.disableSprite(this);
            DisplayObjectUtil.removeFromParent(_numSprite);
            this._numSprite = null;
            this._iconDisplay.initData(null);
            this._info = null;
            return;
        }

        DisplayObjectUtil.enableSprite(this);
        if (param1.count <= 1) {
            DisplayObjectUtil.removeFromParent(_numSprite);
            this._numSprite = null;
        } else if (!_info || _info.count !== param1.count) {
            DisplayObjectUtil.removeFromParent(_numSprite);
            this._numSprite = UINumberGenerator.generateItemNumber(param1.count);
            _numSprite.x = -_numSprite.width;
            _numSprite.mouseChildren = false;
            _numSprite.mouseEnabled = false;
            count.addChild(_numSprite);
        }
        this._iconDisplay.initData(param1.icon);
        this._info = param1;
    }

    public function item():ItemData {
        return this._info;
    }
}
}
