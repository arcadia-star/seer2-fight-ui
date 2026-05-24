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
        this._healthShadowBar.visible = false;
        this._hpSign.visible = false;
        this._angerSign.visible = false;
    }

    override protected function layout(side:int):void {
        super.layout(side);
        this._typeIcon.x = this._iconCover.x + this._iconCover.width - 23;
        this._typeIcon.y = 0;
        this._typeIcon.setScale(30/40,30/40);
        if (side == FightSide.RIGHT) {this._typeIcon.x += 30;}
    }
}
}
