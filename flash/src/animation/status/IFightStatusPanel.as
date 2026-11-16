package animation.status {
import data.pet.ArenaData;
import flash.display.Sprite;

public interface IFightStatusPanel {
    function get view():Sprite;
    function initData(data:ArenaData,smooth:int):void;
    function playAnger(side:int,before:int,after:int):void;
    function whenSettled(done:Function):void;
    function showSkillBubble(side:int,name:String):void;
}
}
