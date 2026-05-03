package utils.an {

import flash.display.DisplayObject;

import utils.an.vibration.HorizontalDrifting;
import utils.an.vibration.VerticalVibration;
import utils.ds.HashMap;

public class ArenaUtil {

    private static var vibrateMap:HashMap = new HashMap(true);

    private static var horizontalDrifting:HorizontalDrifting;

    public static const UNCHECK_ANGER_SKILLS:Array = [10494, 10498, 10503];


    public function ArenaUtil() {
        super();
    }

    public static function startVibrate(param1:DisplayObject):void {
        var _loc2_:VerticalVibration = null;
        if (vibrateMap.containsKey(param1)) {
            _loc2_ = vibrateMap.getValue(param1);
        } else {
            _loc2_ = new VerticalVibration();
            vibrateMap.add(param1, _loc2_);
        }
        _loc2_.vibrate(param1);
    }

    public static function startDrift(param1:int, param2:DisplayObject):void {
        if (horizontalDrifting == null) {
            horizontalDrifting = new HorizontalDrifting();
        }
        horizontalDrifting.drift(param1, param2);
    }
}
}
