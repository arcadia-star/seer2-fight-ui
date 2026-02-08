package animation.status {
import ui.status.UI_FightSPTBossAngerBar;
import ui.status.UI_FightSPTBossHealthBar;
import ui.status.UI_FightSPTBossHealthShadowBar;
import ui.status.UI_FightSPTBossStatusBack;

import utils.an.DisplayUtil;

internal class SPTBossStatusBar extends FighterStatusBar {
    public function SPTBossStatusBar(side:int) {
        super(side);
    }

    override protected function createChildren():void {
        super.createChildren();
        var replaceChild:Function = DisplayUtil.replaceChild;
        _back = replaceChild(_back, new UI_FightSPTBossStatusBack);
        _healthBar = replaceChild(_healthBar, new ShrinkBar(new UI_FightSPTBossHealthBar));
        _angerBar = replaceChild(_angerBar, new AngerBar(new UI_FightSPTBossAngerBar));
        _healthShadowBar = replaceChild(_healthShadowBar, new ShrinkBar(new UI_FightSPTBossHealthShadowBar));
        _iconDisplayer.setSize(83);
        _iconDisplayer.scaleX = -1;
    }

    override protected function layout(side:int):void {
        var setChildPosition:Function = DisplayUtil.setChildPosition;
        setChildPosition(_back, 162, 0);
        setChildPosition(_nameSprite, 877, 104);
        setChildPosition(_levelSprite, 802, 53);
        setChildPosition(_sign, 840, 10);
        setChildPosition(_typeIcon, 785, 52);
        setChildPosition(_iconDisplayer, 952, 10);
        setChildPosition(_hpSign, 637, 13);
        setChildPosition(_healthBar, 833, 10);
        setChildPosition(_healthShadowBar, 833, 10);
        setChildPosition(_angerSign, 657, 33);
        setChildPosition(_angerBar, 835, 32);
    }
}
}
