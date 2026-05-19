package animation.hub {

import animation.event.Events;
import animation.event.OperateEvent;

import data.pet.TeamData;

import flash.display.MovieClip;

import flash.display.Sprite;
import flash.events.Event;

import ui.hub.UI_FightBarBack;

import utils.an.DisplayObjectUtil;

public class FightControlPanel extends Sprite {

    private var _back:MovieClip;

    private var _fightPointPanel:FightPointPanel;

    private var _hubButtonPanel:HubButtonPanel;

    private var _skillPanel:SkillPanel;

    private var _itemPanel:ItemPanel;

    private var _capsulePanel:ItemPanel;

    private var _fighterPanel:FighterPanel;

    private var _currentPanel:Sprite;

    public function FightControlPanel() {
        super();
        this.y = 550;
        this._back = new UI_FightBarBack;
        addChild(this._back);
        this._fightPointPanel = new FightPointPanel(this._back["history"]);
        this._skillPanel = new SkillPanel();
        this._skillPanel.x = 242;
        this._fighterPanel = new FighterPanel();
        this._fighterPanel.x = 311;
        this._fighterPanel.y = 13;
        this._itemPanel = new ItemPanel(false);
        this._capsulePanel = new ItemPanel(true);
        this._capsulePanel.x = this._itemPanel.x = 311;
        this._capsulePanel.y = this._itemPanel.y = 13;
        this._hubButtonPanel = new HubButtonPanel();
        addChild(this._hubButtonPanel);
        this._hubButtonPanel.x = 1010;
        this._hubButtonPanel.addEventListener(HubButtonPanel.EVT_FIGHT, this.onFightClick);
        this._hubButtonPanel.addEventListener(HubButtonPanel.EVT_ITEM, this.onItemClick);
        this._hubButtonPanel.addEventListener(HubButtonPanel.EVT_PET, this.onPetClick);
        this._hubButtonPanel.addEventListener(HubButtonPanel.EVT_ESCAPE, this.onEscapeClick);
        this._hubButtonPanel.addEventListener(HubButtonPanel.EVT_CATCH, this.onCatchClick);
        this._hubButtonPanel.addEventListener(Events.BTN_AUTO_CLICK, this.onAutoClick);
        this._hubButtonPanel.addEventListener(Events.BTN_SETTING_CLICK, this.onSettingClick);
        this.addEventListener(OperateEvent.OPERATE_END, function (event:OperateEvent):void {
            reset()
        });
    }

    public function initData(teamData:TeamData):void {
        this._skillPanel.initData(teamData.master.skills);
        this._fighterPanel.initData(teamData.pets);
        this._itemPanel.initData(teamData.items);
        this._capsulePanel.initData(teamData.capsules);
        reset()
    }

    public function reset():void {
        setCurrentPanel(this._skillPanel);
        this._hubButtonPanel.reset();
    }

    public function showPetPanel():void {
        setCurrentPanel(this._fighterPanel);
    }

    public function appendLogs(logs:Vector.<String>):void {
        this._fightPointPanel.entryValue(logs);
    }

    private function onFightClick(param1:Event):void {
        setCurrentPanel(this._skillPanel);
    }

    private function onItemClick(param1:Event):void {
        setCurrentPanel(this._itemPanel);
    }

    private function onPetClick(param1:Event):void {
        setCurrentPanel(this._fighterPanel);
    }

    private function onCatchClick(param1:Event):void {
        setCurrentPanel(this._capsulePanel);
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
        if (currentPanel === this._currentPanel) {
            return;
        }
        DisplayObjectUtil.removeFromParent(this._currentPanel);
        this._currentPanel = currentPanel;
        addChild(this._currentPanel);
    }
}
}
