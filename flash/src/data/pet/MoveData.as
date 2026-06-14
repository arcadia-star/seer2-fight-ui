package data.pet {
public class MoveData {
    public var side:int;
    public var skill:String;
    public var category:String;
    public var damage:int;
    public var critical:int;
    public var miss:int;
    public var rate:int;
    public var soundUrl:String;
    public var effectUrl:String;
    public var hits:Vector.<int>;

    public static function from(obj:Object):MoveData {
        if (!obj) {
            return null;
        }
        var target:MoveData = new MoveData();
        target.side = obj.side;
        target.skill = obj.skill;
        target.category = obj.category;
        target.damage = obj.damage;
        target.critical = obj.critical;
        target.miss = obj.miss;
        target.rate = obj.rate;
        target.soundUrl = obj.soundUrl;
        target.effectUrl = obj.effectUrl;
        target.hits = transHits(obj.hits);
        return target;
    }

    public static function clone(obj:MoveData):MoveData {
        if (!obj) {
            return null;
        }
        var target:MoveData = new MoveData();
        target.side = obj.side;
        target.skill = obj.skill;
        target.category = obj.category;
        target.damage = obj.damage;
        target.critical = obj.critical;
        target.miss = obj.miss;
        target.rate = obj.rate;
        target.soundUrl = obj.soundUrl;
        target.effectUrl = obj.effectUrl;
        target.hits = cloneHits(obj.hits);
        return target;
    }

    private static function transHits(array:Array):Vector.<int> {
        var res:Vector.<int> = new Vector.<int>();
        if (!array) {
            return res;
        }
        for (var i:int = 0; i < array.length; i++) {
            res.push(array[i] == 0 ? 1 : array[i]);//防止传入数据有0
        }
        return res;
    }

    private static function cloneHits(array:Vector.<int>):Vector.<int> {
        var res:Vector.<int> = new Vector.<int>();
        if (!array) {
            return res;
        }
        for (var i:int = 0; i < array.length; i++) {
            res.push(array[i]);
        }
        return res;
    }
}
}
