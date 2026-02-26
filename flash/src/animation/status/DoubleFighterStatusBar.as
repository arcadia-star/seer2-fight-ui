package animation.status {

import enums.FightSide;

import ui.status.UI_DoubleFightAngerBar;
import ui.status.UI_DoubleFightHealthBar;
import ui.status.UI_DoubleFightHealthShadowBar;
import ui.status.UI_DoubleFightStatusBarBack;

import utils.an.DisplayUtil;

internal class DoubleFighterStatusBar extends FighterStatusBar {

    public function DoubleFighterStatusBar(side:int) {
        super(side);
    }

    override protected function createChildren():void {
        super.createChildren();
        var replaceChild:Function = DisplayUtil.replaceChild;
        _back = replaceChild(_back, new UI_DoubleFightStatusBarBack);
        _healthBar = replaceChild(_healthBar, new ShrinkBar(new UI_DoubleFightHealthBar));
        _angerBar = replaceChild(_angerBar, new AngerBar(new UI_DoubleFightAngerBar));
        _healthShadowBar = replaceChild(_healthShadowBar, new ShrinkBar(new UI_DoubleFightHealthShadowBar));
        _iconDisplayer.setSize(77);
        _typeIcon.visible = false;
        _levelSprite.visible = false;
    }

    override protected function layout(side:int):void {
        var setChildPosition:Function = DisplayUtil.setChildPosition;
        setChildPosition(_iconDisplayer, 6, 7);
        setChildPosition(_sign, 85, 9);
        setChildPosition(_healthShadowBar, 111, 10);
        setChildPosition(_healthBar, 111, 10);
        setChildPosition(_hpSign, 120, 13);
        setChildPosition(_angerBar, 110, 33);
        setChildPosition(_angerSign, 120, 33);
        setChildPosition(_levelSprite, 10, 70);
        setChildPosition(_nameSprite, 4, 90);
        setChildPosition(_typeIcon, 65, 50);
        if (side == FightSide.RIGHT) {
            _sign.scaleX = -1;
            _sign.x = 107;
            _hpSign.scaleX = -1;
            _hpSign.x = 230;
            _angerSign.scaleX = -1;
            _angerSign.x = 230;
            _levelSprite.scaleX = -1;
            _levelSprite.x = 69;
            _nameSprite.scaleX = -1;
            _nameSprite.x = 78;
            _typeIcon.scaleX = -1;
            _typeIcon.x = 65;
            this.scaleX = -1;
        }
    }
}
}
