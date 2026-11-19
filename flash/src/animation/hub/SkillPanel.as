package animation.hub {
import animation.event.OperateEvent;

import data.pet.SkillData;

import enums.SkillCategoryName;

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.MouseEvent;

import utils.an.DisplayObjectUtil;

[Embed(source="/_assets/battle-ui.swf", symbol="SkillPanel")]
public dynamic class SkillPanel extends MovieClip {
    public var skill0:SkillButton;
    public var skill1:SkillButton;
    public var skill2:SkillButton;
    public var skill3:SkillButton;
    public var superSkill:SuperSkillButton;
    public var prev:SimpleButton;
    public var next:SimpleButton;
    private var _skills:Vector.<SkillData>;
    private var _page:int;
    private var _tip:SkillTip = new SkillTip();
    private var _skillBtnVec:Vector.<SkillButton>;

    public function SkillPanel() {
        mouseEnabled = false;
        superSkill.buttonMode = superSkill.useHandCursor = true;
        bindButton(superSkill);
        _skillBtnVec = new <SkillButton>[skill0, skill1, skill2, skill3];
        for each (var button:SkillButton in _skillBtnVec) bindButton(button);
        prev.visible = next.visible = false;
        prev.addEventListener(MouseEvent.CLICK, function (event:MouseEvent):void {
            showPage(_page - 1);
        });
        next.addEventListener(MouseEvent.CLICK, function (event:MouseEvent):void {
            showPage(_page + 1);
        });
    }

    private function bindButton(button:MovieClip):void {
        button.addEventListener(MouseEvent.CLICK, onSkillBtnClick);
        button.addEventListener(MouseEvent.MOUSE_OVER, onSkillBtnOver);
        button.addEventListener(MouseEvent.MOUSE_OUT, onSkillBtnOut);
    }

    public function initData(skills:Vector.<SkillData>):void {
        _skills = new Vector.<SkillData>();
        var power:SkillData;
        for each (var skill:SkillData in skills) {
            if (SkillCategoryName.pow().indexOf(skill.category) >= 0) {
                if (!power) power = skill;
            } else {
                _skills.push(skill);
            }
        }
        superSkill.visible = power != null;
        if (power) superSkill.initData(power);
        showPage(0);
    }

    private function showPage(page:int):void {
        var start:int = page * _skillBtnVec.length;
        if (page < 0 || (page > 0 && start >= _skills.length)) return;

        hideTip();
        _page = page;
        for (var i:int = 0; i < _skillBtnVec.length; i++) {
            var button:SkillButton = _skillBtnVec[i];
            var index:int = start + i;
            button.visible = index < _skills.length;
            if (button.visible) button.initData(_skills[index]);
        }
        prev.visible = next.visible = _skills.length > _skillBtnVec.length;
        prev.enabled = prev.mouseEnabled = page > 0;
        next.enabled = next.mouseEnabled = start + _skillBtnVec.length < _skills.length;
    }

    public function hideTip():void {
        DisplayObjectUtil.removeFromParent(this._tip);
    }

    private function onSkillBtnOver(event:MouseEvent):void {
        var button:MovieClip = MovieClip(event.currentTarget);
        this._tip.initData(ISkillButton(button).skill());
        this._tip.x = button.x + 20;
        this._tip.y = button.y - 10;
        this.addChild(this._tip);
        event.stopImmediatePropagation();
    }

    private function onSkillBtnOut(event:MouseEvent):void {
        hideTip();
        event.stopImmediatePropagation();
    }

    private function onSkillBtnClick(event:MouseEvent):void {
        hideTip();
        var button:MovieClip = MovieClip(event.currentTarget);
        this.dispatchEvent(OperateEvent.skill(ISkillButton(button).skill().id));
    }
}
}
