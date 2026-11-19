package animation.hub {

import animation.event.Events;
import animation.event.OperateEvent;

import data.pet.ItemData;
import data.pet.TeamData;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;

[Embed(source="/_assets/battle-ui.swf", symbol="FightControlPanel")]
public dynamic class FightControlPanel extends MovieClip {

    public var back:MovieClip;
    public var deposit:MovieClip;
    public var hub:HubButtonPanel;
    public var skills:SkillPanel;
    public var fighters:FighterPanel;
    public var items:ItemPanel;
    public var capsules:ItemPanel;

    private var _fightPointPanel:FightPointPanel;

    private var _currentPanel:Sprite;

    public function FightControlPanel() {
        deposit.stop();
        deposit.visible = deposit.mouseChildren = deposit.mouseEnabled = false;
        _fightPointPanel = new FightPointPanel(back.history);
        for each (var panel:Sprite in [skills, fighters, items, capsules]) {
            panel.visible = panel.mouseChildren = panel.mouseEnabled = false;
        }
        items.configure(false, selectItemTarget);
        capsules.configure(true);
        this.hub.addEventListener(HubButtonPanel.EVT_FIGHT, this.onFightClick);
        this.hub.addEventListener(HubButtonPanel.EVT_ITEM, this.onItemClick);
        this.hub.addEventListener(HubButtonPanel.EVT_PET, this.onPetClick);
        this.hub.addEventListener(HubButtonPanel.EVT_ESCAPE, this.onEscapeClick);
        this.hub.addEventListener(HubButtonPanel.EVT_CATCH, this.onCatchClick);
        this.hub.addEventListener(Events.BTN_AUTO_CLICK, this.onAutoClick);
        this.hub.addEventListener(Events.BTN_SETTING_CLICK, this.onSettingClick);
    }

    public function initData(teamData:TeamData):void {
        this.skills.initData(teamData.master.skills);
        this.fighters.initData(teamData.pets);
        this.items.initData(teamData.items);
        this.capsules.initData(teamData.capsules);
        reset();
    }

    public function reset():void {
        setCurrentPanel(this.skills);
        this.hub.reset();
    }

    public function showPetPanel():void {
        setCurrentPanel(this.fighters);
    }

    public function appendLogs(logs:Vector.<String>):void {
        this._fightPointPanel.entryValue(logs);
    }

    public function updateAutoFightStatus(show:Boolean):void {
        if (this.deposit.visible === show) {
            return;
        }
        this.deposit.visible = show;
        if (show) {
            this.deposit.gotoAndPlay(1);
        } else {
            //隐藏时停止播放节约cpu开销
            this.deposit.gotoAndStop(1);
        }
    }

    private function onFightClick(param1:Event):void {
        setCurrentPanel(this.skills);
    }

    private function onItemClick(param1:Event):void {
        setCurrentPanel(this.items);
    }

    private function selectItemTarget(item:ItemData):void {
        showPetPanel();
        this.fighters.setTargetItem(item);
    }

    private function onPetClick(param1:Event):void {
        setCurrentPanel(this.fighters);
    }

    private function onCatchClick(param1:Event):void {
        setCurrentPanel(this.capsules);
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
        this.fighters.setTargetItem(null);
        if (currentPanel === this._currentPanel) {
            return;
        }
        if (this._currentPanel) {
            if (this._currentPanel === this.skills) this.skills.hideTip();
            this._currentPanel.visible = this._currentPanel.mouseEnabled = this._currentPanel.mouseChildren = false;
        }
        this._currentPanel = currentPanel;
        currentPanel.visible = currentPanel.mouseEnabled = currentPanel.mouseChildren = true;
    }

    public function enableFightControlPanel(enabled:Boolean):void {
        if (!enabled) skills.hideTip();
        hub.enableHubPanel(enabled);
        skills.mouseEnabled = skills.mouseChildren = enabled;
    }
}
}
