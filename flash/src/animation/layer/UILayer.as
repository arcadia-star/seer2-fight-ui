package animation.layer {
import animation.hub.FightControlPanel;
import animation.status.Double2v1FightStatusPanel;
import animation.status.DoubleFightStatusPanel;
import animation.status.FightStatusPanel;
import animation.status.SPTFightStatusPanel;

import data.pet.ArenaData;
import data.pet.MoveData;

import flash.display.Sprite;

import utils.an.DisplayUtil;

public class UILayer extends Sprite {
    private var _uiStyle:int = 0;
    private var _controlPanel:FightControlPanel;
    private var _statusPanel:FightStatusPanel;
    private var _arenaData:ArenaData;

    public function UILayer() {
        this._controlPanel = new FightControlPanel();
        this._statusPanel = new FightStatusPanel();
        addChild(_controlPanel);
        addChild(_statusPanel);
    }

    public function initData(arenaData:ArenaData, smooth:int):void {
        this._arenaData = arenaData;
        this._controlPanel.initData(arenaData.left);
        this._statusPanel.initData(arenaData, smooth);
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

    public function updateUiStyle(uiStyle:int):void {
        if (_uiStyle === uiStyle) {
            return;
        }
        _uiStyle = uiStyle;
        if (_uiStyle === 1) {
            this._statusPanel = DisplayUtil.replaceChild(_statusPanel, new SPTFightStatusPanel());
        } else if (_uiStyle === 2) {
            this._statusPanel = DisplayUtil.replaceChild(_statusPanel, new DoubleFightStatusPanel());
        } else if (_uiStyle === 3) {
            this._statusPanel = DisplayUtil.replaceChild(_statusPanel, new Double2v1FightStatusPanel());
        } else {
            this._statusPanel = DisplayUtil.replaceChild(_statusPanel, new FightStatusPanel());
        }
        if (_arenaData) {
            this._statusPanel.initData(_arenaData, 0);
        }
    }

    public function get controlPanel():FightControlPanel {
        return _controlPanel;
    }
}
}
