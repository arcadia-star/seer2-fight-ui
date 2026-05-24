package animation.hub {

import data.pet.ItemData;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.text.TextField;

import ui.hub.UI_FightItemTip;

internal class ItemTip extends Sprite {


    private var _content:MovieClip;

    private var _back:MovieClip;

    private var _nameText:TextField;

    private var _desText:TextField;
    private var _lastName:String = null;
    private var _lastTips:String = null;

    private const TXT_WIDTH:int = 46;

    public function ItemTip() {
        super();
        this.initialize();
    }

    private function initialize():void {
        this.mouseChildren = false;
        this.mouseEnabled = false;
        this.createChildren();
    }

    private function createChildren():void {
        this._content = new UI_FightItemTip;
        this._back = this._content["back"];
        this._nameText = this._content["txtName"];
        this._desText = this._content["txtDes"];
        this._desText.wordWrap = true;
        this._desText.multiline = true;
        addChild(this._content);
    }

    public function initData(param1:ItemData):void {
        var tips:String = param1.tips || '';
        if (this._lastName === param1.name && this._lastTips === tips) {
            return;
        }
        this._lastName = param1.name;
        this._lastTips = tips;
        this._nameText.text = param1.name;
        this._desText.htmlText = tips;
        this._desText.height = this._desText.textHeight + 5;
        this._back.height = this._desText.height + 35;
        this._nameText.y = -1 * this._back.height + 5;
        this._desText.y = -1 * this._back.height + 20;
    }
}
}
