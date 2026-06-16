package data.location {
import enums.FightPosition;
import enums.FightSide;

public class FighterLocation {
    public var targetX:Number = 0;
    public var targetY:Number = 0;
    public var targetScaleX:Number = 1;
    public var targetScaleY:Number = 1;

    public static var MAIN_FIGHTER_Y:int = 90 - 40;//和原版相比，22主位上移40
    public static var SUB_FIGHTER_Y:int = -5;
    public static var FIX_SCALE:Number = 0.55;

    public static var WIDTH:Number = 1200;
    public static var HEIGHT:Number = 660;

    public static function build(side:int, position:int):FighterLocation {

        var _loc1_:FighterLocation = new FighterLocation();
        if (position == FightPosition.MAIN) {
            if (side == FightSide.RIGHT) {
                _loc1_.targetScaleX = -1;
                _loc1_.targetX = WIDTH - 120;
            } else {
                _loc1_.targetScaleX = 1;
                _loc1_.targetX = 120;
            }
            _loc1_.targetScaleY = 1;
            _loc1_.targetY += MAIN_FIGHTER_Y;
        } else {
            if (side == FightSide.RIGHT) {
                _loc1_.targetScaleX = -1 * FIX_SCALE;
                _loc1_.targetX = ((1 - FIX_SCALE) / 2 + FIX_SCALE) * WIDTH - 120;
            } else {
                _loc1_.targetScaleX = FIX_SCALE;
                _loc1_.targetX = (1 - FIX_SCALE) * WIDTH / 2 + 120;
            }
            _loc1_.targetScaleY = FIX_SCALE;
            _loc1_.targetY = (1 - FIX_SCALE) * HEIGHT / 2;
            _loc1_.targetY += SUB_FIGHTER_Y * FIX_SCALE;
        }
        return _loc1_;
    }
}
}
