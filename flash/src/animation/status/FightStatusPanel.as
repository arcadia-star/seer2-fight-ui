package animation.status {
import animation.status.skins.*;

import data.pet.ArenaData;

import enums.FightSide;

import flash.display.MovieClip;

[Embed(source="/_assets/battle-ui.swf", symbol="UI_FightStatusLayout")]
public dynamic class FightStatusPanel extends MovieClip {
    // AIR needs an explicit reference to link classes instantiated by the SWF timeline.
    private static const STATUS_SYMBOLS:Array = [
        NormalLeftFighter, WideRightFighter, SPTLeftFighter, SPTRightFighter,
        DoubleLeftFighter, DoubleRightFighter, DoubleLeftSubFighter, DoubleRightSubFighter,
        NormalLeftBuffs, WideRightBuffs, SPTLeftBuffs, SPTRightBuffs,
        DoubleLeftBuffs, DoubleRightBuffs, LeftSkillBubbleSkin, RightSkillBubbleSkin
    ];

    public var leftFighter:NormalFighterStatusBar;
    public var rightFighter:NormalFighterStatusBar;
    public var leftSub:NormalFighterStatusBar;
    public var rightSub:NormalFighterStatusBar;
    public var leftBuffs:NormalBuffIconBar;
    public var rightBuffs:NormalBuffIconBar;
    public var leftCapsules:NormalCapsuleBar;
    public var rightCapsules:NormalCapsuleBar;
    public var leftSkill:NormalSkillBubble;
    public var rightSkill:NormalSkillBubble;
    public var title:MovieClip;
    public var weather:NormalWeatherDisplay;

    public function FightStatusPanel() {
        title.stop();
        leftCapsules.initLayout("left");
        rightCapsules.initLayout("right");
    }

    public function initData(data:ArenaData, smooth:int):void {
        leftFighter.initData(data.left.master, smooth);
        rightFighter.initData(data.right.master, smooth);
        leftBuffs.initData(data.left.master);
        rightBuffs.initData(data.right.master);
        leftCapsules.initData(data.left.pets);
        rightCapsules.initData(data.right.pets);
        if (leftSub) leftSub.initData(data.left.slave, smooth);
        if (rightSub) rightSub.initData(data.right.slave, smooth);
        updateTitle(data.round);
        weather.initData(data.weatherIcon, data.weatherTips);
    }

    public function playAnger(side:int, before:int, after:int):void {
        (side == FightSide.LEFT ? leftFighter : rightFighter).playAnger(before, after);
    }

    public function whenSettled(done:Function):void {
        var remaining:int = 2 + int(leftSub != null) + int(rightSub != null);

        function complete():void {
            if (--remaining == 0) done();
        }

        leftFighter.whenSettled(complete);
        rightFighter.whenSettled(complete);
        if (leftSub) leftSub.whenSettled(complete);
        if (rightSub) rightSub.whenSettled(complete);
    }

    public function showSkillBubble(side:int, name:String):void {
        (side == FightSide.LEFT ? leftSkill : rightSkill).setSkillName(name);
    }

    private function updateTitle(round:int):void {
        if (round / 100 >= 1) {
            title.gotoAndStop(3);
            title.count0.gotoAndStop(int(round / 100) + 1);
            title.count1.gotoAndStop(int(round % 100 / 10) + 1);
            title.count2.gotoAndStop(round % 100 % 10 + 1);
        } else if (round / 10 >= 1) {
            title.gotoAndStop(2);
            title.count0.gotoAndStop(int(round / 10) + 1);
            title.count1.gotoAndStop(round % 10 + 1);
        } else {
            title.gotoAndStop(1);
            title.count0.gotoAndStop(round + 1);
        }
    }
}
}
