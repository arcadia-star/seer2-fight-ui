package animation.hub {

import animation.event.OperateEvent;

import data.pet.SkillData;

import enums.SkillCategoryName;

import flash.display.Sprite;
import flash.events.MouseEvent;

import utils.an.DisplayObjectUtil;

internal class SkillPanel extends Sprite {

    private static const SKILL_BTN_NUM:int = 4;

    private var _tip:SkillTip;

    private var _skillBtnVec:Vector.<SkillButton>;

    private var _superSkillBtn:SuperSkillButton;

    public function SkillPanel() {
        var offsetX:int;
        var offsetY:int;
        var btnWidth:int;
        var i:int;
        var onSkillBtnOver:Function;
        var onSkillBtnOut:Function;
        var skillBtn:SkillButton = null;
        super();
        onSkillBtnOver = function (param1:MouseEvent):void {
            var _loc2_:Sprite;
            _loc2_ = param1.currentTarget as Sprite;
            _tip.initData((param1.currentTarget as ISkillButton).skill());
            _tip.x = _loc2_.x + 20;
            _tip.y = _loc2_.y - 10;
            addChild(_tip);
            param1.stopImmediatePropagation();
        };
        onSkillBtnOut = function (param1:MouseEvent):void {
            DisplayObjectUtil.removeFromParent(_tip);
            param1.stopImmediatePropagation();
        };
        this.mouseEnabled = false;
        this._superSkillBtn = new SuperSkillButton();
        this._superSkillBtn.x = 3;
        this._superSkillBtn.y = 3;
        this._superSkillBtn.buttonMode = true;
        this._superSkillBtn.useHandCursor = true;
        addChild(this._superSkillBtn);
        this._superSkillBtn.addEventListener(MouseEvent.CLICK, this.onSkillBtnClick);
        this._superSkillBtn.addEventListener(MouseEvent.MOUSE_OVER, onSkillBtnOver);
        this._superSkillBtn.addEventListener(MouseEvent.MOUSE_OUT, onSkillBtnOut);
        offsetX = 84;
        offsetY = 20;
        btnWidth = 171;
        this._skillBtnVec = new Vector.<SkillButton>();
        i = 0;
        while (i < SKILL_BTN_NUM) {
            skillBtn = new SkillButton();
            skillBtn.x = offsetX + i * btnWidth;
            skillBtn.y = offsetY;
            skillBtn.addEventListener(MouseEvent.CLICK, this.onSkillBtnClick);
            skillBtn.addEventListener(MouseEvent.MOUSE_OVER, onSkillBtnOver);
            skillBtn.addEventListener(MouseEvent.MOUSE_OUT, onSkillBtnOut);
            this._skillBtnVec.push(skillBtn);
            i++;
        }
        this._tip = new SkillTip();
    }

    public function initData(skills:Vector.<SkillData>):void {
        this.showNormalSkillBtn(skills);
        this.showSuperSkillBtn(skills);
    }

    private function showNormalSkillBtn(param1:Vector.<SkillData>):void {
        var i:int;
        var count:int = 0;
        for (i = 0; i < param1.length; i++) {
            var skill:SkillData = param1[i];
            if (SkillCategoryName.pow().indexOf(skill.category) >= 0) {
                continue;
            }
            if (count >= SKILL_BTN_NUM) {
                break;
            }
            var button:SkillButton = this._skillBtnVec[count];
            button.initData(skill);
            if (!button.parent) {
                addChild(button);
            }
            count++;
        }
        for (i = count; i < SKILL_BTN_NUM; i++) {
            button = this._skillBtnVec[i];
            DisplayObjectUtil.removeFromParent(button);
        }
    }

    private function showSuperSkillBtn(param1:Vector.<SkillData>):void {
        var button:SuperSkillButton = this._superSkillBtn;
        var powSkill:SkillData = null;
        for (var i:int = 0; i < param1.length; i++) {
            var skill:SkillData = param1[i];
            if (SkillCategoryName.pow().indexOf(skill.category) >= 0) {
                powSkill = skill;
                break;
            }
        }
        if (powSkill) {
            button.initData(powSkill);
            if (!button.parent) {
                addChild(button);
            }
        } else {
            DisplayObjectUtil.removeFromParent(button);
        }
    }

    private function onSkillBtnClick(param1:MouseEvent):void {
        var skillBtn:ISkillButton = param1.currentTarget as ISkillButton;
        dispatchEvent(OperateEvent.skill(skillBtn.skill().id));
    }
}
}
