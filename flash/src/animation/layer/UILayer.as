package animation.layer {
import animation.hub.FightControlPanel;
import animation.status.Double2v1FightStatusPanel;
import animation.status.DoubleFightStatusPanel;
import animation.status.FightStatusPanel;
import animation.status.SPTFightStatusPanel;
import animation.status.YuCunFightStatusPanel;

import data.pet.ArenaData;
import data.pet.MoveData;

import flash.display.Sprite;

import animation.hub.UI_FightControlLayout;

import utils.an.DisplayUtil;

public class UILayer extends Sprite {
    private var _uiStyle:int = 0;
    private var _controlPanel:FightControlPanel;
    private var _statusPanel:FightStatusPanel;
    private var _arenaData:ArenaData;

    public function UILayer() {
        var controlLayout:UI_FightControlLayout = new UI_FightControlLayout();
        this._controlPanel = controlLayout.controlPanel;
        this._statusPanel = new FightStatusPanel();
        addChild(controlLayout);
        addChild(_statusPanel);
    }

    public function initData(arenaData:ArenaData, smooth:int):void {
        this._arenaData = arenaData;
        this._controlPanel.initData(arenaData.left);
        this._statusPanel.initData(arenaData, smooth);
    }

    public function playAnger(side:int, before:int, after:int):void {
        this._statusPanel.playAnger(side, before, after);
    }

    public function whenSettled(done:Function):void {
        this._statusPanel.whenSettled(done);
    }

    public function showSkillBubble(move:MoveData):void {
        if (!move || !move.skill) {
            return;
        }
        this._statusPanel.showSkillBubble(move.side, move.skill);
    }

    public function showPetPanel():void {
        this._controlPanel.showPetPanel();
    }

    public function appendLogs(logs:Vector.<String>):void {
        this._controlPanel.appendLogs(logs);
    }

    public function updateAutoFightStatus(show:Boolean):void {
        this._controlPanel.updateAutoFightStatus(show);
    }

    public function updateUiStyle(uiStyle:int):void {
        if (_uiStyle === uiStyle) {
            return;
        }
        _uiStyle = uiStyle;
        var next:FightStatusPanel;
        if (_uiStyle === 1) {
            next = new SPTFightStatusPanel();
        } else if (_uiStyle === 2) {
            next = new DoubleFightStatusPanel();
        } else if (_uiStyle === 3) {
            next = new Double2v1FightStatusPanel();
        } else if (_uiStyle === 4) {
            next = new YuCunFightStatusPanel();
        } else {
            next = new FightStatusPanel();
        }
        DisplayUtil.replaceChild(_statusPanel, next);
        _statusPanel = next;
        if (_arenaData) {
            this._statusPanel.initData(_arenaData, 0);
        }
    }

    public function get controlPanel():FightControlPanel {
        return _controlPanel;
    }
}
}
