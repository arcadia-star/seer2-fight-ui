package animation.hub {

import animation.event.Events;
import animation.event.OperateEvent;
import ui.hub.UI_FightControlLayout;

import data.pet.TeamData;
import data.pet.ItemData;

import flash.display.DisplayObject;

import flash.display.MovieClip;

import flash.display.Sprite;
import flash.events.Event;

public class FightControlPanel extends UI_FightControlLayout {

    private var _view:MovieClip;

    private var _back:MovieClip;

    private var _fightPointPanel:FightPointPanel;

    private var _hubButtonPanel:HubButtonPanel;

    private var _skillPanel:SkillPanel;

    private var _itemPanel:ItemPanel;

    private var _capsulePanel:ItemPanel;

    private var _fighterPanel:FighterPanel;

    private var _currentPanel:Sprite;

    private var _depositMc:MovieClip;
    private var _teamData:TeamData;

    public function FightControlPanel() {
        super();
        this._view = getChildByName("controlPanel") as MovieClip;
        this._back = _view.getChildByName("back") as MovieClip;
        this._depositMc = _view.getChildByName("deposit") as MovieClip;
        this._depositMc.stop();
        this._depositMc.visible = this._depositMc.mouseChildren = this._depositMc.mouseEnabled = false;
        this._fightPointPanel = new FightPointPanel(this._back["history"]);
        this._skillPanel = new SkillPanel(_view.getChildByName("skills") as MovieClip);
        this._skillPanel.view.visible = this._skillPanel.view.mouseChildren = this._skillPanel.view.mouseEnabled = false;
        this._fighterPanel = new FighterPanel(_view.getChildByName("fighters") as MovieClip);
        this._fighterPanel.view.visible = this._fighterPanel.view.mouseChildren = this._fighterPanel.view.mouseEnabled = false;
        this._itemPanel = new ItemPanel(false, _view.getChildByName("items") as MovieClip);
        this._itemPanel.view.addEventListener(OperateEvent.OPERATE_END, this.onItemSelected);
        this._capsulePanel = new ItemPanel(true, _view.getChildByName("capsules") as MovieClip);
        this._itemPanel.view.visible = this._itemPanel.view.mouseChildren = this._itemPanel.view.mouseEnabled = false;
        this._capsulePanel.view.visible = this._capsulePanel.view.mouseChildren = this._capsulePanel.view.mouseEnabled = false;
        this._hubButtonPanel = new HubButtonPanel(_view.getChildByName("hub") as MovieClip);
        this._hubButtonPanel.addEventListener(HubButtonPanel.EVT_FIGHT, this.onFightClick);
        this._hubButtonPanel.addEventListener(HubButtonPanel.EVT_ITEM, this.onItemClick);
        this._hubButtonPanel.addEventListener(HubButtonPanel.EVT_PET, this.onPetClick);
        this._hubButtonPanel.addEventListener(HubButtonPanel.EVT_ESCAPE, this.onEscapeClick);
        this._hubButtonPanel.addEventListener(HubButtonPanel.EVT_CATCH, this.onCatchClick);
        this._hubButtonPanel.addEventListener(Events.BTN_AUTO_CLICK, this.onAutoClick);
        this._hubButtonPanel.addEventListener(Events.BTN_SETTING_CLICK, this.onSettingClick);
    }

    public function initData(teamData:TeamData):void {
        this._teamData = teamData;
        this._skillPanel.initData(teamData.master.skills);
        this._fighterPanel.initData(teamData.pets);
        this._itemPanel.initData(teamData.items);
        this._capsulePanel.initData(teamData.capsules);
        reset()
    }

    public function reset():void {
        setCurrentPanel(this._skillPanel.view);
        this._hubButtonPanel.reset();
    }

    public function showPetPanel():void {
        setCurrentPanel(this._fighterPanel.view);
    }

    public function appendLogs(logs:Vector.<String>):void {
        this._fightPointPanel.entryValue(logs);
    }

    public function updateAutoFightStatus(show:Boolean):void {
        if (this._depositMc.visible === show) {
            return;
        }
        this._depositMc.visible = show;
        if (show) {
            this._depositMc.gotoAndPlay(1);
        } else {
            //隐藏时停止播放节约cpu开销
            this._depositMc.gotoAndStop(1);
        }
    }

    private function onFightClick(param1:Event):void {
        setCurrentPanel(this._skillPanel.view);
    }

    private function onItemClick(param1:Event):void {
        setCurrentPanel(this._itemPanel.view);
    }

    private function onItemSelected(event:OperateEvent):void {
        for each (var item:ItemData in this._teamData.items) {
            if (item.id != event.data.item) continue;
            if (item.type === 17) {
                // 与 Flash 客户端一致：选药只打开精灵面板，选定目标才提交操作。
                event.stopImmediatePropagation();
                setCurrentPanel(this._fighterPanel.view);
                this._fighterPanel.setReviveItem(item.id);
            } else {
                event.data.target = this._teamData.master.pid;
            }
            return;
        }
        throw new Error("选中的药水不在当前道具列表中：" + event.data.item);
    }

    private function onPetClick(param1:Event):void {
        setCurrentPanel(this._fighterPanel.view);
    }

    private function onCatchClick(param1:Event):void {
        setCurrentPanel(this._capsulePanel.view);
    }

    private function onEscapeClick(param1:Event):void {
        dispatchEvent(OperateEvent.escape(1));
    }

    private function onAutoClick(param1:Event):void {
        dispatchEvent(OperateEvent.autoFight());
    }

    private function onSettingClick(param1:Event):void {
        dispatchEvent(OperateEvent.setting());
    }

    private function setCurrentPanel(currentPanel:Sprite):void {
        this._fighterPanel.setReviveItem(0);
        if (currentPanel === this._currentPanel) {
            return;
        }
        if (this._currentPanel) {
            if (this._currentPanel === this._skillPanel.view) this._skillPanel.hideTip();
            this._currentPanel.visible = this._currentPanel.mouseEnabled = this._currentPanel.mouseChildren = false;
        }
        this._currentPanel = currentPanel;
        if (this._currentPanel) {
            this._currentPanel.visible = this._currentPanel.mouseEnabled = this._currentPanel.mouseChildren = true;
        }
    }

    public function enableFightControlPanel(able:Boolean):void {
        if (!able) this._skillPanel.hideTip();
        //由于自动按钮和设置按钮也加入了controlPanel,全部disable确实不太合适
        for (var i:int = 0; i < _view.numChildren; i++) {
            var child:DisplayObject = _view.getChildAt(i);
            if (child == this._hubButtonPanel.view) {
                this._hubButtonPanel.enableHubPanel(able);
                continue;
            }
            if (child == this._back) continue;
            //每回合出招阶段会自动切换至技能面板,其他面板是否接受鼠标动作无所谓
            if (child == this._skillPanel.view) {
                Sprite(child).mouseEnabled = able;
                Sprite(child).mouseChildren = able;
            }
        }
    }
}
}
