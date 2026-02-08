package data {
import enums.FightSide;

import flash.display.MovieClip;

import ui.PetFallback;

public class FightPet {
    public static const UNREACHABLE_URL:String = "unreachable";

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
        fighter.url = UNREACHABLE_URL;
        fighter.pet = new PetFallback;
        fighter.pet.visible = false;
        return fighter;
    }
}
}
