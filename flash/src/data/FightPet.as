package data {
import enums.FightSide;

import flash.display.MovieClip;

public class FightPet {
    public var x:int;
    public var y:int;
    public var scaleX:int;

    public var url:String;
    public var pet:MovieClip;

    public static function build(side:Number):FightPet {
        var fighter:FightPet = new FightPet();
        if (FightSide.LEFT === side) {
            fighter.x = 120;
            fighter.y = 50;
            fighter.scaleX = 1;
        } else {
            fighter.x = 1200 - 120;
            fighter.y = 50;
            fighter.scaleX = -1;
        }
        fighter.url = null;
        fighter.pet = null;
        return fighter;
    }
}
}
