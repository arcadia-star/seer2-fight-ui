package animation.hub {

import data.pet.SkillData;

import flash.display.MovieClip;
import flash.display.Sprite;

import ui.hub.UI_FightSuperSkill;

internal class SuperSkillButton extends Sprite implements ISkillButton {

    private var _mc:MovieClip;

    private var _skillInfo:SkillData;
    private var _lastFrame:int = int.MIN_VALUE;

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
        var targetFrame:int = param1.enable ? 2 : 1;
        if (this._lastFrame !== targetFrame) {
            this._mc.gotoAndStop(targetFrame);
            this._lastFrame = targetFrame;
        }
    }

    public function skill():SkillData {
        return _skillInfo;
    }
}
}
