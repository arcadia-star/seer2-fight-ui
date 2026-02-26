package animation.status {
import enums.FightSide;

import ui.status.UI_SubFightAngerBar;
import ui.status.UI_SubFightHealthBar;
import ui.status.UI_SubFightStatusBarBack;

import utils.an.DisplayUtil;

public class SubFighterStatusBar extends FighterStatusBar {

    public function SubFighterStatusBar(side:int) {
        super(side);
    }

    override protected function createChildren():void {
        super.createChildren();
        var replaceChild:Function = DisplayUtil.replaceChild;
        _back = replaceChild(_back, new UI_SubFightStatusBarBack);
        _healthBar = replaceChild(_healthBar, new ShrinkBar(new UI_SubFightHealthBar));
        _angerBar = replaceChild(_angerBar, new ShrinkBar(new UI_SubFightAngerBar));
        _sign.scaleX = _sign.scaleY = 0.7
        _iconDisplayer.setBoundary(52, 52);
        _healthShadowBar.visible = false;
        _hpSign.visible = false;
        _angerSign.visible = false;
        _typeIcon.visible = false;
        _levelSprite.visible = false;
    }

    override protected function layout(side:int):void {
        var setChildPosition:Function = DisplayUtil.setChildPosition;
        setChildPosition(this._nameSprite, 0, 62);
        setChildPosition(this._sign, 64, 2);
        setChildPosition(this._iconDisplayer, 10, 5);
        setChildPosition(this._healthBar, 78, 5);
        setChildPosition(this._angerBar, 78, 17);
        setChildPosition(this._levelSprite, 7, 45);
        if (side == FightSide.RIGHT) {
            this._sign.scaleX = -1 * this._sign.scaleX;
            this._sign.x = 78;
            this._levelSprite.scaleX = -1 * this._levelSprite.scaleX;
            this._levelSprite.x = 60;
            this._nameSprite.scaleX = -1;
            this._nameSprite.x = 75;
            this.scaleX = -1;
        }
    }
}
}
