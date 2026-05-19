package animation.status {
import ui.status.UI_FightSPTBossStatusBarBack;

import utils.an.DisplayUtil;

internal class SPTBossStatusBar extends BaseFighterStatusBar {
    public function SPTBossStatusBar(side:int) {
        super(side);
    }

    override protected function createChildren():void {
        this._back = new UI_FightSPTBossStatusBarBack;
        addChild(this._back);
        super.createChildren();
        this._typeIcon.setSize(16);
        this._iconDisplayer.scaleX = -1;
    }

    override protected function layout(side:int):void {
        var setChildPosition:Function = DisplayUtil.setChildPosition;
        setChildPosition(this._iconDisplayer, this._iconCover.x + this._iconCover.width, this._iconCover.y);
        setChildPosition(this._levelSprite, this._levelBg.x + 1, this._levelBg.y + 2);
        setChildPosition(this._typeIcon, this._levelBg.x - 16, this._levelBg.y);
        setChildPosition(this._hpSign, 520, 12);
        setChildPosition(this._angerSign, 570, 33);
    }
}
}
