package animation.hub {

import animation.common.IconDisplay;

import data.pet.SkillData;

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.text.TextField;

import ui.hub.UI_FightSkillBrief;
import ui.hub.UI_FightSkillBtn;

import utils.an.DisplayObjectUtil;

internal class SkillButton extends Sprite implements ISkillButton {

    private var _btn:SimpleButton;

    private var _brief:MovieClip;

    private var _typeIcon:IconDisplay;

    private var _nameTxt:TextField;

    private var _angerValueTxt:TextField;

    private var _powerTxt:TextField;

    private var _powerValueTxt:TextField;

    private var _categoryTxt:TextField;

    private var _info:SkillData;

    public function SkillButton() {
        super();
        this.createChildren();
    }

    private function createChildren():void {
        this._btn = new UI_FightSkillBtn;
        addChild(this._btn);
        this._brief = new UI_FightSkillBrief;
        addChild(this._brief);
        this._brief.mouseChildren = false;
        this._brief.mouseEnabled = false;
        var _loc1_:TextField = this._brief["txtAnger"];
        _loc1_.text = "怒气";
        this._nameTxt = this._brief["txtSkillName"];
        this._angerValueTxt = this._brief["txtAngerValue"];
        this._angerValueTxt.text = "0";
        this._powerTxt = this._brief["txtPower"];
        this._powerTxt.text = "威力";
        this._powerValueTxt = this._brief["txtPowerValue"];
        this._powerValueTxt.text = "0";
        this._categoryTxt = this._brief["txtSkillCategory"];
        this._typeIcon = new IconDisplay();
        this._typeIcon.setSize(40);
        DisplayObjectUtil.disableSprite(this._typeIcon);
        this._typeIcon.x = 11;
        this._typeIcon.y = 13;
        addChild(this._typeIcon);
    }

    public function initData(param1:SkillData):void {
        this._info = param1;
        this._nameTxt.text = this._info.name;
        this._angerValueTxt.text = this._info.anger.toString();
        this._powerValueTxt.text = this._info.power.toString();
        this._categoryTxt.text = this._info.category;
        this._typeIcon.initData(this._info.typeIcon);
        if (param1.enable) {
            DisplayObjectUtil.recoverDisplayObject(this);
        } else {
            DisplayObjectUtil.darkenDisplayObject(this);
        }
    }

    public function skill():SkillData {
        return this._info;
    }
}
}
