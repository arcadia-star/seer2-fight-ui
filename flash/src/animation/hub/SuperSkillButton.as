package animation.hub {

import data.pet.SkillData;

import flash.display.MovieClip;

[Embed(source="/_assets/battle-ui.swf", symbol="SuperSkillButton")]
public dynamic class SuperSkillButton extends MovieClip implements ISkillButton {
    public var mc:MovieClip;

    private var _skillInfo:SkillData;

    public function initData(param1:SkillData):void {
        this._skillInfo = param1;
        if (param1.enable) {
            mc.gotoAndStop(2);
        } else {
            mc.gotoAndStop(1);
        }
    }

    public function skill():SkillData {
        return _skillInfo;
    }
}
}
