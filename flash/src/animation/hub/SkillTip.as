package animation.hub {

import data.pet.SkillData;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

import ui.hub.UI_FightSkillTip;

import utils.an.DisplayObjectUtil;

internal class SkillTip extends Sprite {


    private var _tip:MovieClip;

    private var _back:MovieClip;

    private var _descriptionTxt:TextField;

    public function SkillTip() {
        super();
        this.initialize();
    }

    private function initialize():void {
        DisplayObjectUtil.disableSprite(this);
        this._tip = new UI_FightSkillTip;
        this._back = this._tip["backMc"];
        this._descriptionTxt = this._tip["txtDes"];
        this._descriptionTxt.selectable = false;
        this._descriptionTxt.mouseEnabled = false;
        this._descriptionTxt.autoSize = TextFieldAutoSize.LEFT;
        this._descriptionTxt.wordWrap = true;
        addChild(this._tip);
    }

    public function initData(param1:SkillData):void {
        this._descriptionTxt.htmlText = param1.tips || '';
        _back.height = Math.max(110.55, _descriptionTxt.height + 26);
        _descriptionTxt.y = 8 - _back.height;

    }
}
}
