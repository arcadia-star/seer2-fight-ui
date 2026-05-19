package animation.status {
import enums.FightSide;
import ui.status.UI_SubFightStatusBarBack;

import utils.an.DisplayUtil;

public class SubFighterStatusBar extends BaseFighterStatusBar{

    public function SubFighterStatusBar(side:int) {
        super(side);
    }

    override protected function createChildren():void {
        this._back = new UI_SubFightStatusBarBack;
        addChild(this._back);
        super.createChildren();
        _typeIcon.setSize(16);
        _healthShadowBar.visible = false;
        _hpSign.visible = false;
        _angerSign.visible = false;
        _typeIcon.visible = false;
    }

    override protected function layout(side:int):void {
        super.layout(side);
    }
}
}
