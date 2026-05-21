package animation.hub {

import animation.event.Events;
import animation.event.OperateEvent;

import data.pet.TeamData;

import flash.display.DisplayObject;

import flash.display.MovieClip;

import flash.display.Sprite;
import flash.events.Event;

import ui.hub.New_UI_DepositTxt;
import ui.hub.UI_FightBarBack;

public class FightControlPanel extends Sprite {

    private var _back:MovieClip;

    private var _fightPointPanel:FightPointPanel;

    private var _hubButtonPanel:HubButtonPanel;

    private var _skillPanel:SkillPanel;

    private var _itemPanel:ItemPanel;

    private var _capsulePanel:ItemPanel;

    private var _fighterPanel:FighterPanel;

    private var _currentPanel:Sprite;

    private var _depositMc:MovieClip;

    public function FightControlPanel() {
        super();
        this.y = 550;
        this._back = new UI_FightBarBack;
        addChild(this._back);
        this._depositMc = new New_UI_DepositTxt;
        this._depositMc.x = 445;
        this._depositMc.y = -350;
        addChild(this._depositMc);
        this._depositMc.visible = this._depositMc.mouseChildren = this._depositMc.mouseEnabled = false;
        this._fightPointPanel = new FightPointPanel(this._back["history"]);
        this._skillPanel = new SkillPanel();
        this._skillPanel.x = 242;
        addChild(this._skillPanel);
        this._skillPanel.visible = this._skillPanel.mouseChildren = this._skillPanel.mouseEnabled = false;
        this._fighterPanel = new FighterPanel();
        this._fighterPanel.x = 311;
        this._fighterPanel.y = 13;
        addChild(this._fighterPanel);
        this._fighterPanel.visible = this._fighterPanel.mouseChildren = this._fighterPanel.mouseEnabled = false;
        this._itemPanel = new ItemPanel(false);
        this._capsulePanel = new ItemPanel(true);
        this._capsulePanel.x = this._itemPanel.x = 311;
        this._capsulePanel.y = this._itemPanel.y = 13;
        addChild(this._itemPanel);
        addChild(this._capsulePanel);
        this._itemPanel.visible = this._itemPanel.mouseChildren = this._itemPanel.mouseEnabled = false;
        this._capsulePanel.visible = this._capsulePanel.mouseChildren = this._capsulePanel.mouseEnabled = false;
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
        this._depositMc.visible = !this._depositMc.visible;
        if(this._depositMc.visible) this._depositMc.gotoAndPlay(1);
        else this._depositMc.gotoAndStop(1);
        //隐藏时停止播放节约cpu开销
        dispatchEvent(OperateEvent.autoFight());
    }

    private function onSettingClick(param1:Event):void {
        dispatchEvent(OperateEvent.setting());
    }

    private function setCurrentPanel(currentPanel:Sprite):void {
        if (currentPanel === this._currentPanel) {
            return;
        }
        if(this._currentPanel) {
            this._currentPanel.visible = this._currentPanel.mouseEnabled = this._currentPanel.mouseChildren = false;
        }
        this._currentPanel = currentPanel;
        if(this._currentPanel) {
            this._currentPanel.visible = this._currentPanel.mouseEnabled = this._currentPanel.mouseChildren = true;
        }
    }

    public function enableFightControlPanel(able:Boolean):void {
        //由于自动按钮和设置按钮也加入了controlPanel,全部disable确实不太合适
        for(var i:int = 0; i < numChildren; i++) {
            var child:DisplayObject = getChildAt(i);
            if(child == this._hubButtonPanel) {
                this._hubButtonPanel.enableHubPanel(able);
                continue;
            }
            if(child == this._back) continue;
            //每回合出招阶段会自动切换至技能面板,其他面板是否接受鼠标动作无所谓
            if(child == this._skillPanel) {
                Sprite(child).mouseEnabled = able;
                Sprite(child).mouseChildren = able;
            }
        }
    }
}
}
