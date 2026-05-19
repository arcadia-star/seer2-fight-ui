package animation.status {

import ui.status.UI_FightSPTFighterStatusBarBack;

import utils.an.DisplayUtil;

internal class SPTFighterStatusBar extends BaseFighterStatusBar {
    public function SPTFighterStatusBar(side:int) {
        super(side);
    }

    override protected function createChildren():void {
        this._back = new UI_FightSPTFighterStatusBarBack;
        addChild(this._back);
        super.createChildren();
        this._typeIcon.setSize(16);
    }

    override protected function layout(side:int):void {
        super.layout(side);
        var setChildPosition:Function = DisplayUtil.setChildPosition;
        setChildPosition(_hpSign, 200, 34);
        setChildPosition(_angerSign, 200, 51);
    }
}
}
