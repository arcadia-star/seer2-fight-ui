package animation.layer {
import animation.hub.FightControlPanel;
import animation.status.FightStatusPanel;

import data.pet.ArenaData;
import data.pet.MoveData;

import flash.display.Sprite;

public class UILayer extends Sprite {
    private var _controlPanel:FightControlPanel;
    private var _statusPanel:FightStatusPanel;

    public function UILayer() {
        this._controlPanel = new FightControlPanel();
        this._statusPanel = new FightStatusPanel();
        addChild(_controlPanel);
        addChild(_statusPanel);
    }

    public function initData(arenaData:ArenaData):void {
        this._controlPanel.initData(arenaData.left);
        this._statusPanel.initData(arenaData);
    }

    public function showSkillBubble(move:MoveData):void {
        if (!move || !move.skill) {
            return;
        }
        this._statusPanel.showSkillBubble(move.side, move.skill);
    }

    public function appendLogs(logs:Vector.<String>):void {
        this._controlPanel.appendLogs(logs);
    }
}
}
