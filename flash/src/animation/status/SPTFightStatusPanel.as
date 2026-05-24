package animation.status {
import enums.FightSide;

import utils.an.DisplayUtil;

public class SPTFightStatusPanel extends FightStatusPanel {
    public function SPTFightStatusPanel() {
    }

    override protected function createChildren():void {
        super.createChildren();
        var replaceChild:Function = DisplayUtil.replaceChild;
        _leftMainFighterBar = replaceChild(_leftMainFighterBar, new SPTFighterStatusBar(FightSide.LEFT));
        _rightMainFighterBar = replaceChild(_rightMainFighterBar, new SPTBossStatusBar(FightSide.RIGHT));
    }

    override protected function layout():void {
        _rightCapsuleBar.scaleX *= -1;
        this._title.y = 35;
        this._weatherDisplay.y = 74;
        var setChildPosition:Function = DisplayUtil.setChildPosition;
        setChildPosition(_leftMainFighterBar, 0, 20);
        setChildPosition(_rightMainFighterBar, 410, 0);
        setChildPosition(_leftCapsuleBar, 4, 130);
        setChildPosition(_leftBuffIconBar, 106, 92);
//        setChildPosition(_leftSkillBubble, 0, 140);
//        setChildPosition(_rightSkillBubble, 1200, 150);
        setChildPosition(_rightCapsuleBar, 1194, 130);
        setChildPosition(_rightBuffIconBar, 978, 54);
    }
}
}
