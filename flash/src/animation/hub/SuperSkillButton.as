package animation.hub {

import data.pet.SkillData;

import flash.display.MovieClip;

internal class SuperSkillButton implements ISkillButton {

    private var _view:MovieClip;

    public function get view():MovieClip { return _view; }

    private var _mc:MovieClip;

    private var _skillInfo:SkillData;

    public function SuperSkillButton(view:MovieClip) {
        this._view = view;
        this._mc = view["mc"];
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
