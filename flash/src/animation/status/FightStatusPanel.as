package animation.status {

import data.pet.ArenaData;
import data.pet.MoveData;

import enums.FightSide;

import flash.display.MovieClip;
import flash.display.Sprite;

import ui.status.New_UI_FighterTitle;

import utils.an.DisplayUtil;

public class FightStatusPanel extends Sprite {


    protected var _arenaData:ArenaData;

    protected var _leftMainFighterBar:BaseFighterStatusBar;

    protected var _leftBuffIconBar:BuffIconBar;

    protected var _leftCapsuleBar:CapsuleBarPet;

    protected var _leftSkillBubble:SkillBubble;

    protected var _leftAngerStatus:AngerStatusPanel;

    protected var _rightMainFighterBar:BaseFighterStatusBar;

    protected var _rightBuffIconBar:BuffIconBar;

    protected var _rightCapsuleBar:CapsuleBarPet;

    protected var _rightSkillBubble:SkillBubble;

    protected var _rightAngerStatus:AngerStatusPanel;

    protected var _title:MovieClip;

    protected var _weatherDisplay:FightWeatherDisplay;

    public function FightStatusPanel() {
        super();
        this.createChildren();
        this.layout();
    }

    public function initData(param1:ArenaData, smooth:int):void {
        this._arenaData = param1;
        this._leftMainFighterBar.initData(param1.left.master, smooth);
        this._leftBuffIconBar.initData(param1.left.master);
        this._leftCapsuleBar.initData(param1.left.pets);
        this._leftAngerStatus.setFight(param1.left.master);
        this._rightMainFighterBar.initData(param1.right.master, smooth);
        this._rightBuffIconBar.initData(param1.right.master);
        this._rightCapsuleBar.initData(param1.right.pets);
        CapsuleBarPet.petShown(param1.right.pets.indexOf(param1.right.master));
        this._rightAngerStatus.setFight(param1.right.master);
        this.updateTitle();
        this._weatherDisplay.initData(param1.weatherIcon, param1.weatherTips);
    }

    private function updateTitle():void {
        var _loc1_:int = _arenaData.round;
        if (_loc1_ / 100 >= 1) {
            this._title.gotoAndStop(3);
            this._title["count0"].gotoAndStop(int(_loc1_ / 100) + 1);
            this._title["count1"].gotoAndStop(int(_loc1_ % 100 / 10) + 1);
            this._title["count2"].gotoAndStop(_loc1_ % 100 % 10 + 1);
        } else if (_loc1_ / 10 >= 1) {
            this._title.gotoAndStop(2);
            this._title["count0"].gotoAndStop(int(_loc1_ / 10) + 1);
            this._title["count1"].gotoAndStop(_loc1_ % 10 + 1);
        } else {
            this._title.gotoAndStop(1);
            this._title["count0"].gotoAndStop(_loc1_ + 1);
        }
    }

    public function showSkillBubble(side:int, param2:String):void {
        if (side == FightSide.LEFT) {
            this._leftSkillBubble.setSkillName(param2);
        } else {
            this._rightSkillBubble.setSkillName(param2);
        }
    }

    protected function createChildren():void {
        this._leftCapsuleBar = new CapsuleBarPet(CapsuleBarPet.CAPSULE_SIDE_LEFT);
        addChild(this._leftCapsuleBar);
        this._rightCapsuleBar = new CapsuleBarPet(CapsuleBarPet.CAPSULE_SIDE_RIGHT);
        addChild(this._rightCapsuleBar);
        _leftMainFighterBar = new FighterStatusBar(FightSide.LEFT);
        addChild(_leftMainFighterBar);
        _rightMainFighterBar = new FighterStatusBar(FightSide.RIGHT);
        addChild(_rightMainFighterBar);
        this._leftBuffIconBar = new BuffIconBar(FightSide.LEFT);
        addChild(this._leftBuffIconBar);
        this._rightBuffIconBar = new BuffIconBar(FightSide.RIGHT);
        addChild(this._rightBuffIconBar);
        this._leftSkillBubble = new SkillBubble(FightSide.LEFT);
        addChild(this._leftSkillBubble);
        this._rightSkillBubble = new SkillBubble(FightSide.RIGHT);
        addChild(this._rightSkillBubble);
        this._leftAngerStatus = new AngerStatusPanel(FightSide.LEFT);
        addChild(this._leftAngerStatus);
        this._rightAngerStatus = new AngerStatusPanel(FightSide.RIGHT);
        addChild(this._rightAngerStatus);
        this._title = new New_UI_FighterTitle;
        this._title.x = 520;
        this._title.gotoAndStop(0);
        this._title["count0"].gotoAndStop(0);
        addChild(this._title);
        this._weatherDisplay = new FightWeatherDisplay();
        _weatherDisplay.x = 540;
        _weatherDisplay.y = 40;
        addChild(_weatherDisplay);
    }

    protected function layout():void {
        _rightCapsuleBar.scaleX *= -1;
        var setChildPosition:Function = DisplayUtil.setChildPosition;
        setChildPosition(_rightMainFighterBar, 1200, 0);
        setChildPosition(_leftBuffIconBar, 174, 55);
        setChildPosition(_rightBuffIconBar, 994, 55);
        setChildPosition(_leftCapsuleBar, 6, 125);
        setChildPosition(_rightCapsuleBar, 1194, 125);
    }

}
}
