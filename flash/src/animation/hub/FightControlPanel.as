package animation.hub {

import animation.event.OperateEvent;

import data.pet.TeamData;

import flash.display.Sprite;
import flash.events.Event;

import ui.hub.UI_FightBarBack;

import utils.an.DisplayObjectUtil;

public class FightControlPanel extends Sprite {

    private var _fightPointPanel:FightPointPanel;

    private var _hubButtonPanel:HubButtonPanel;

    private var _skillPanel:SkillPanel;

    private var _itemPanel:ItemPanel;

    private var _capsulePanel:ItemPanel;

    private var _fighterPanel:FighterPanel;

    private var _currentPanel:Sprite;

    public function FightControlPanel() {
        super();
        this.x = 246;
        this.y = 513;
        addChild(new UI_FightBarBack);
        this._fightPointPanel = new FightPointPanel();
        this._fightPointPanel.x -= this.x + 10;
        this._fightPointPanel.y = 27 - 3;
        addChild(this._fightPointPanel);
        this._skillPanel = new SkillPanel();
        this._skillPanel.y = 41;
        this._fighterPanel = new FighterPanel();
        this._itemPanel = new ItemPanel(false);
        this._capsulePanel = new ItemPanel(true);
        this._hubButtonPanel = new HubButtonPanel();
        addChild(this._hubButtonPanel);
        this._hubButtonPanel.addEventListener(HubButtonPanel.EVT_FIGHT, this.onFightClick);
        this._hubButtonPanel.addEventListener(HubButtonPanel.EVT_ITEM, this.onItemClick);
        this._hubButtonPanel.addEventListener(HubButtonPanel.EVT_PET, this.onPetClick);
        this._hubButtonPanel.addEventListener(HubButtonPanel.EVT_ESCAPE, this.onEscapeClick);
        this._hubButtonPanel.addEventListener(HubButtonPanel.EVT_CATCH, this.onCatchClick);
        this.addEventListener(OperateEvent.OPERATE_END, function (event:OperateEvent):void {
            reset()
        })
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
