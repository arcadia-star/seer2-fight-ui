package animation.status {

import enums.FightSide;

import ui.status.UI_DoubleFightStatusBarBack;

import utils.an.DisplayUtil;

public class DoubleFighterStatusBar extends BaseFighterStatusBar {

    public function DoubleFighterStatusBar(side:int) {
        super(side);
    }

    override protected function createChildren():void {
        this._back = new UI_DoubleFightStatusBarBack
        addChild(this._back);
        super.createChildren();
        this._typeIcon.setSize(16);
        this._typeIcon.visible = false;
    }

    override protected function layout(side:int):void {
        super.layout(side);
        var setChildPosition:Function = DisplayUtil.setChildPosition;
        setChildPosition(_hpSign, 173, 12);
        setChildPosition(_angerSign, 173, 32);
    }
}
}
