package data.pet {
public class EndData {
    public var winner:int;

    public static function from(obj:Object):EndData {
        if (!obj) {
            return null;
        }
        var target:EndData = new EndData();
        target.winner = obj.winner;
        return target;
    }

    public static function clone(obj:EndData):EndData {
        if (!obj) {
            return null;
        }
        var target:EndData = new EndData();
        target.winner = obj.winner;
        return target;
    }
}
}
