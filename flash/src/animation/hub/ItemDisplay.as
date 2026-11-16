package animation.hub {

import animation.common.IconDisplay;

import data.pet.ItemData;

import flash.display.Sprite;
import flash.display.MovieClip;

import ui.UINumberGenerator;
import utils.an.DisplayObjectUtil;

internal class ItemDisplay {

    private var _view:MovieClip;

    public function get view():MovieClip { return _view; }


    private var _info:ItemData;

    private var _iconDisplay:IconDisplay;

    private var _numSprite:Sprite;

    public function ItemDisplay(view:MovieClip) {
        this._view = view;
        this._view.mouseChildren = false;
        this._view.buttonMode = true;
        this._iconDisplay = new IconDisplay();
        MovieClip(_view["icon"]).addChild(this._iconDisplay);
        _iconDisplay.setSize(60);
        DisplayObjectUtil.disableSprite(this._iconDisplay);
        DisplayObjectUtil.disableSprite(this._view);
    }

    public function initData(param1:ItemData):void {
        if (_info === param1) {
            return;
        }
        if (!param1) {
            DisplayObjectUtil.disableSprite(this._view);
            DisplayObjectUtil.removeFromParent(_numSprite);
            this._numSprite = null;
            this._iconDisplay.initData(null);
            this._info = null;
            return;
        }

        DisplayObjectUtil.enableSprite(this._view);
        if (param1.count <= 1) {
            DisplayObjectUtil.removeFromParent(_numSprite);
            this._numSprite = null;
        } else if (!_info || _info.count !== param1.count) {
            DisplayObjectUtil.removeFromParent(_numSprite);
            this._numSprite = UINumberGenerator.generateItemNumber(param1.count);
            _numSprite.x = -_numSprite.width;
            _numSprite.mouseChildren = false;
            _numSprite.mouseEnabled = false;
            MovieClip(_view["count"]).addChild(_numSprite);
        }
        this._iconDisplay.initData(param1.icon);
        this._info = param1;
    }

    public function item():ItemData {
        return this._info;
    }
}
}
