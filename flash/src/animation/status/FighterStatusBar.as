package animation.status {
import enums.FightSide;

import ui.status.UI_FightStatusBarBack;

import utils.an.DisplayUtil;

public class FighterStatusBar extends BaseFighterStatusBar {
    public function FighterStatusBar(side:int) {
        super(side);
    }

    override protected function createChildren():void {
        this._back = new UI_FightStatusBarBack;
        addChild(this._back);
        super.createChildren();
    }

    override protected function layout(side:int):void {
        super.layout(side);
        this._healthShadowBar.visible = false;
        var setChildPosition:Function = DisplayUtil.setChildPosition;
        setChildPosition(this._hpSign, 220, 11);
        setChildPosition(this._angerSign, 220, 32);
    }
}
}
