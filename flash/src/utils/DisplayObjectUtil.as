package utils {
import flash.display.DisplayObject;

public class DisplayObjectUtil {
    public function DisplayObjectUtil() {
    }

    public static function removeFromParent(param1:DisplayObject):void {
        if (Boolean(param1) && param1.parent != null) {
            param1.parent.removeChild(param1);
        }
    }
}
}
