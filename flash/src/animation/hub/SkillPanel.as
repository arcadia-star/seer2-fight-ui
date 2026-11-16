package animation.hub {
import animation.event.OperateEvent;
import data.pet.SkillData;
import enums.SkillCategoryName;
import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.utils.Dictionary;
import utils.an.DisplayObjectUtil;

internal class SkillPanel {
    private static const SKILL_BTN_NUM:int = 4;
    private var _view:MovieClip;
    private var _tip:SkillTip = new SkillTip();
    private var _skillBtnVec:Vector.<SkillButton> = new Vector.<SkillButton>();
    private var _superSkillBtn:SuperSkillButton;
    private var _buttons:Dictionary = new Dictionary();

    public function get view():MovieClip { return _view; }

    public function SkillPanel(view:MovieClip) {
        this._view = view;
        view.mouseEnabled = false;
        this._superSkillBtn = new SuperSkillButton(view["superSkill"]);
        this._superSkillBtn.view.buttonMode = true;
        this._superSkillBtn.view.useHandCursor = true;
        bindButton(this._superSkillBtn);
        for (var i:int = 0; i < SKILL_BTN_NUM; i++) {
            var button:SkillButton = new SkillButton(view["skill" + i]);
            this._skillBtnVec.push(button);
            bindButton(button);
        }
    }

    private function bindButton(button:ISkillButton):void {
        this._buttons[button.view] = button;
        button.view.addEventListener(MouseEvent.CLICK, onSkillBtnClick);
        button.view.addEventListener(MouseEvent.MOUSE_OVER, onSkillBtnOver);
        button.view.addEventListener(MouseEvent.MOUSE_OUT, onSkillBtnOut);
    }

    public function initData(skills:Vector.<SkillData>):void {
        var normal:Vector.<SkillData> = new Vector.<SkillData>();
        var power:Vector.<SkillData> = new Vector.<SkillData>();
        for each (var skill:SkillData in skills) {
            if (SkillCategoryName.pow().indexOf(skill.category) >= 0) power.push(skill);
            else normal.push(skill);
        }
        for (var i:int = 0; i < SKILL_BTN_NUM; i++) {
            var button:SkillButton = this._skillBtnVec[i];
            button.view.visible = i < normal.length;
            if (button.view.visible) button.initData(normal[i]);
        }
        this._superSkillBtn.view.visible = power.length > 0;
        if (this._superSkillBtn.view.visible) this._superSkillBtn.initData(power[0]);
    }

    public function hideTip():void {
        DisplayObjectUtil.removeFromParent(this._tip);
    }

    private function onSkillBtnOver(event:MouseEvent):void {
        var button:ISkillButton = this._buttons[event.currentTarget];
        this._tip.initData(button.skill());
        this._tip.x = button.view.x + 20;
        this._tip.y = button.view.y - 10;
        this._view.addChild(this._tip);
        event.stopImmediatePropagation();
    }

    private function onSkillBtnOut(event:MouseEvent):void {
        hideTip();
        event.stopImmediatePropagation();
    }

    private function onSkillBtnClick(event:MouseEvent):void {
        hideTip();
        var button:ISkillButton = this._buttons[event.currentTarget];
        this._view.dispatchEvent(OperateEvent.skill(button.skill().id));
    }
}
}
