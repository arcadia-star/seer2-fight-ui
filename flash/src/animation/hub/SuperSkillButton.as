package animation.hub {

import data.pet.SkillData;

import flash.display.MovieClip;
import flash.display.Sprite;

import ui.hub.UI_FightSuperSkill;

internal class SuperSkillButton extends Sprite implements ISkillButton {

    private var _mc:MovieClip;

    private var _skillInfo:SkillData;

    public function SuperSkillButton() {
        super();
        this.createChildren();
    }

    private function createChildren():void {
        this._mc = new UI_FightSuperSkill;
        addChild(this._mc);
    }

    public function initData(param1:SkillData):void {
        this._skillInfo = param1;
        if (param1.enable) {
            this._mc.gotoAndStop(2);
        } else {
            this._mc.gotoAndStop(1);
        }
    }

    public function skill():SkillData {
        return _skillInfo;
    }
}
}
