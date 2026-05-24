package animation.status {
import data.pet.ArenaData;
import data.pet.MoveData;

import enums.FightSide;

import utils.an.DisplayUtil;

public class DoubleFightStatusPanel extends FightStatusPanel {

    private var _leftSubFighterBar:SubFighterStatusBar;

    private var _rightSubFighterBar:SubFighterStatusBar;

    public function DoubleFightStatusPanel() {
        super();
    }

    override public function initData(param1:ArenaData, param2:int):void {
        super.initData(param1, param2);
        this._leftSubFighterBar.initData(param1.left.slave, param2);
        this._rightSubFighterBar.initData(param1.right.slave, param2);
    }

    override protected function createChildren():void {
        super.createChildren();
        _leftSubFighterBar = new SubFighterStatusBar(FightSide.LEFT);
        addChild(_leftSubFighterBar);
        _rightSubFighterBar = new SubFighterStatusBar(FightSide.RIGHT);
        addChild(_rightSubFighterBar);
        var replaceChild:Function = DisplayUtil.replaceChild;
        _leftMainFighterBar = replaceChild(_leftMainFighterBar, new DoubleFighterStatusBar(FightSide.LEFT));
        _rightMainFighterBar = replaceChild(_rightMainFighterBar, new DoubleFighterStatusBar(FightSide.RIGHT));
        _leftBuffIconBar = replaceChild(_leftBuffIconBar, new BuffIconBar(FightSide.LEFT, 5));
        _rightBuffIconBar = replaceChild(_rightBuffIconBar, new BuffIconBar(FightSide.RIGHT, 5));
    }

    override protected function layout():void {
        _rightCapsuleBar.scaleX *= -1;
        var setChildPosition:Function = DisplayUtil.setChildPosition;
        setChildPosition(_rightMainFighterBar, 1200, 0);
        setChildPosition(_leftBuffIconBar, 85, 55);
        setChildPosition(_rightBuffIconBar, 1083, 55);
        setChildPosition(_leftCapsuleBar, 6, 125);
        setChildPosition(_rightCapsuleBar, 1194, 125);
        //sub
        setChildPosition(_leftSubFighterBar, 260, 2);
        setChildPosition(_rightSubFighterBar, 940, 2);
    }
}
}
