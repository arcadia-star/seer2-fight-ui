package animation.status {
import data.pet.ArenaData;
import data.pet.MoveData;

import enums.FightSide;

import utils.an.DisplayUtil;

public class Double2v1FightStatusPanel extends FightStatusPanel {

    private var _leftSubFighterBar:SubFighterStatusBar;

    public function Double2v1FightStatusPanel() {
        super();
    }

    override public function initData(param1:ArenaData, param2:int):void {
        super.initData(param1, param2);
        this._leftSubFighterBar.initData(param1.left.slave, param2);
    }

    override protected function createChildren():void {
        super.createChildren();
        var replaceChild:Function = DisplayUtil.replaceChild;
        _leftMainFighterBar = replaceChild(_leftMainFighterBar, new DoubleFighterStatusBar(FightSide.LEFT));
        _rightMainFighterBar = replaceChild(_rightMainFighterBar, new FighterStatusBar(FightSide.RIGHT));
        //_rightMainFighterBar = replaceChild(_rightMainFighterBar, new SPTBossStatusBar(FightSide.RIGHT));
        _leftBuffIconBar = replaceChild(_leftBuffIconBar, new BuffIconBar(FightSide.LEFT, 5));
        _leftSubFighterBar = new SubFighterStatusBar(FightSide.LEFT);
        addChildAt(_leftSubFighterBar, getChildIndex(_rightMainFighterBar));
    }

    override protected function layout():void {
        _rightCapsuleBar.scaleX *= -1;
        var setChildPosition:Function = DisplayUtil.setChildPosition;
        setChildPosition(_rightMainFighterBar, 1200, 0);
        //setChildPosition(_rightMainFighterBar, 242, 0);
        setChildPosition(_rightBuffIconBar, 994, 55);
        setChildPosition(_leftBuffIconBar, 85, 55);
        setChildPosition(_leftCapsuleBar, 6, 125);
        setChildPosition(_rightCapsuleBar, 1194, 125);
        //sub
        setChildPosition(_leftSubFighterBar, 260, 2);
    }
}
}
