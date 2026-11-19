package animation.hub {

import animation.common.IconDisplay;

import data.pet.SkillData;

import flash.display.MovieClip;

import utils.an.DisplayObjectUtil;

[Embed(source="/_assets/battle-ui.swf", symbol="SkillButton")]
public dynamic class SkillButton extends MovieClip implements ISkillButton {
    public var brief:MovieClip;
    public var typeIcon:MovieClip;

    private var _typeIcon:IconDisplay;

    private var _info:SkillData;

    public function SkillButton() {
        brief.mouseChildren = false;
        brief.mouseEnabled = false;
        brief.txtAnger.text = "怒气";
        brief.txtAngerValue.text = "0";
        brief.txtPower.text = "威力";
        brief.txtPowerValue.text = "0";
        this._typeIcon = new IconDisplay();
        typeIcon.addChild(this._typeIcon);
        this._typeIcon.setScale(1, 1);
        DisplayObjectUtil.disableSprite(typeIcon);
    }

    public function initData(param1:SkillData):void {
        this._info = param1;
        brief.txtSkillName.text = this._info.name;
        brief.txtAngerValue.text = this._info.anger.toString();
        brief.txtPowerValue.text = this._info.power.toString();
        brief.txtSkillCategory.text = this._info.category;
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
