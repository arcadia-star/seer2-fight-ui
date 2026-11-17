package animation.status {
import data.pet.ArenaData;
import enums.FightSide;
import flash.display.MovieClip;
import flash.display.Sprite;
import ui.status.UI_FightStatusLayout;

public class FightStatusPanel implements IFightStatusPanel {
    private var _root:MovieClip;
    protected var _view:MovieClip;
    private var _arenaData:ArenaData;
    private var _leftMainFighterBar:NormalFighterStatusBar;
    private var _rightMainFighterBar:NormalFighterStatusBar;
    private var _leftBuffIconBar:NormalBuffIconBar;
    private var _rightBuffIconBar:NormalBuffIconBar;
    private var _leftCapsuleBar:NormalCapsuleBar;
    private var _rightCapsuleBar:NormalCapsuleBar;
    private var _leftSkillBubble:NormalSkillBubble;
    private var _rightSkillBubble:NormalSkillBubble;
    private var _title:MovieClip;
    private var _weatherDisplay:NormalWeatherDisplay;
    private var _subNames:Array;
    private var _subFighters:Vector.<NormalFighterStatusBar>=new Vector.<NormalFighterStatusBar>();
    public function get view():Sprite {return _root;}
    public function FightStatusPanel(root:MovieClip=null,subNames:Array=null) {
        _root=root || new UI_FightStatusLayout();
        _subNames=subNames || [];
        _view=_root["statusPanel"];
        _leftMainFighterBar=new NormalFighterStatusBar(_view["leftFighter"]);
        _rightMainFighterBar=new NormalFighterStatusBar(_view["rightFighter"]);
        _leftBuffIconBar=new NormalBuffIconBar(_view["leftBuffs"]);
        _rightBuffIconBar=new NormalBuffIconBar(_view["rightBuffs"]);
        _leftCapsuleBar=new NormalCapsuleBar(_view["leftCapsules"]);
        _rightCapsuleBar=new NormalCapsuleBar(_view["rightCapsules"]);
        _leftSkillBubble=new NormalSkillBubble(_view["leftSkill"]);
        _rightSkillBubble=new NormalSkillBubble(_view["rightSkill"]);
        _title=_view["title"];_title.stop();
        _weatherDisplay=new NormalWeatherDisplay(_view["weather"]);
        for each(var name:String in _subNames)_subFighters.push(new NormalFighterStatusBar(_view[name]));
    }
    public function initData(data:ArenaData,smooth:int):void {
        _arenaData=data;
        _leftMainFighterBar.initData(data.left.master,smooth);_rightMainFighterBar.initData(data.right.master,smooth);
        _leftBuffIconBar.initData(data.left.master);_rightBuffIconBar.initData(data.right.master);
        _leftCapsuleBar.initData(data.left.pets);_rightCapsuleBar.initData(data.right.pets);
        updateTitle();_weatherDisplay.initData(data.weatherIcon,data.weatherTips);
        for(var i:int=0;i<_subNames.length;i++)_subFighters[i].initData(_subNames[i]=="leftSub"?data.left.slave:data.right.slave,smooth);
    }
    public function playAnger(side:int,before:int,after:int):void {
        (side==FightSide.LEFT?_leftMainFighterBar:_rightMainFighterBar).playAnger(before,after);
    }
    public function whenSettled(done:Function):void {
        var remaining:int=2+_subFighters.length;
        function complete():void {remaining--;if(remaining==0)done();}
        _leftMainFighterBar.whenSettled(complete);_rightMainFighterBar.whenSettled(complete);
        for each(var bar:NormalFighterStatusBar in _subFighters)bar.whenSettled(complete);
    }
    public function showSkillBubble(side:int,name:String):void {
        (side==FightSide.LEFT?_leftSkillBubble:_rightSkillBubble).setSkillName(name);
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

}
}
