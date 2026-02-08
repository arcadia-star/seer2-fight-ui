package animation.status {

import ui.status.UI_FightSPTFighterAngerBar;
import ui.status.UI_FightSPTFighterHealthBar;
import ui.status.UI_FightSPTFighterHealthShadowBar;
import ui.status.UI_FightSPTFighterStatusBack;

import utils.an.DisplayUtil;

internal class SPTFighterStatusBar extends FighterStatusBar {
    public function SPTFighterStatusBar(side:int) {
        super(side);
    }

    override protected function createChildren():void {
        super.createChildren();
        var replaceChild:Function = DisplayUtil.replaceChild;
        _back = replaceChild(_back, new UI_FightSPTFighterStatusBack);
        _healthBar = replaceChild(_healthBar, new ShrinkBar(new UI_FightSPTFighterHealthBar));
        _angerBar = replaceChild(_angerBar, new AngerBar(new UI_FightSPTFighterAngerBar));
        _healthShadowBar = replaceChild(_healthShadowBar, new ShrinkBar(new UI_FightSPTFighterHealthShadowBar));
        _iconDisplayer.setSize(61);
    }

    override protected function layout(side:int):void {
        var setChildPosition:Function = DisplayUtil.setChildPosition;
        setChildPosition(_back, 0, 15);
        setChildPosition(_sign, 80, 50);
        setChildPosition(_levelSprite, 78, 31);
        setChildPosition(_nameSprite, 3, 93);
        setChildPosition(_iconDisplayer, 12, 22);
        setChildPosition(_sign, 82, 52);
        setChildPosition(_hpSign, 170, 52);
        setChildPosition(_healthShadowBar, 109, 54);
        setChildPosition(_healthBar, 109, 54);
        setChildPosition(_angerSign, 200, 70);
        setChildPosition(_angerBar, 109, 70);
        setChildPosition(_typeIcon, 140, 28);
    }
}
}
