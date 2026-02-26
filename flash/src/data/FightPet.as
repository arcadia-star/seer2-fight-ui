package data {
import data.location.FighterLocation;

import enums.FightPosition;
import enums.FightSide;

import flash.display.MovieClip;

import ui.PetFallback;

public class FightPet {
    public static const UNREACHABLE_URL:String = "unreachable";

    public var side:int;
    public var position:int;
    public var depth:int;

    public var x:Number;
    public var y:Number;
    public var scaleX:Number;
    public var scaleY:Number;

    public var url:String;
    public var pet:MovieClip;

    public static function build(side:int, position:int):FightPet {
        var fighter:FightPet = new FightPet();
        fighter.side = side;
        fighter.position = position;
        if (side === FightSide.RIGHT) {
            fighter.depth += 1;
        }
        if (position === FightPosition.MAIN) {
            fighter.depth += 2;
        }
        var location:FighterLocation = FighterLocation.build(side, position);
        fighter.x = location.targetX;
        fighter.y = location.targetY;
        fighter.scaleX = location.targetScaleX;
        fighter.scaleY = location.targetScaleY;
        fighter.url = UNREACHABLE_URL;
        fighter.pet = new PetFallback;
        fighter.pet.visible = false;
        return fighter;
    }
}
}
