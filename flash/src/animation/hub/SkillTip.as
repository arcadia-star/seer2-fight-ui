package animation.hub {

import data.pet.SkillData;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import ui.hub.UI_FightSkillTip;

import utils.an.DisplayObjectUtil;

internal class SkillTip extends Sprite {


    private var _tip:MovieClip;

    private var _back:MovieClip;

    private var _descriptionTxt:TextField;
    private var _lastTips:String = null;

    public function SkillTip() {
        super();
        this.initialize();
    }

    private function initialize():void {
        var _loc1_:TextFormat = null;
        DisplayObjectUtil.disableSprite(this);
        this._tip = new UI_FightSkillTip;
        this._back = this._tip["backMc"];
        this._descriptionTxt = this._tip["txtDes"];
        _loc1_ = new TextFormat("", 10);
        this._descriptionTxt.textColor = 16777215;
        this._descriptionTxt.selectable = false;
        this._descriptionTxt.mouseEnabled = false;
        this._descriptionTxt.defaultTextFormat = _loc1_;
        this._descriptionTxt.autoSize = TextFieldAutoSize.LEFT;
        this._descriptionTxt.wordWrap = true;
        addChild(this._tip);
    }

    public function initData(param1:SkillData):void {
        var tips:String = param1.tips || '';
        if (this._lastTips === tips) {
            return;
        }
        this._lastTips = tips;
        this._descriptionTxt.htmlText = tips;
        _back.height = Math.max(110.55, _descriptionTxt.height + 20);
        _descriptionTxt.y = 5 - _back.height;
    }
}
}
