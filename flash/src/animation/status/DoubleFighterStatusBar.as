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
    }

    override protected function layout(side:int):void {
        super.layout(side);
        var setChildPosition:Function = DisplayUtil.setChildPosition;
        setChildPosition(this._hpSign, 173, 12);
        setChildPosition(this._angerSign, 173, 32);
        this._typeIcon.x = this._iconCover.x + this._iconCover.width - 30;
        this._typeIcon.y = 0;
        this._typeIcon.setScale(1,1);
        if (side == FightSide.RIGHT) {this._typeIcon.x += 40;}
    }
}
}
