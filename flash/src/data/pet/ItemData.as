package data.pet {

public class ItemData {
    public var id:int;
    // null 由调用方直接处理；数组表示需要选择目标。
    public var targetPids:Vector.<uint>;
    public var name:String;
    public var count:int;
    public var icon:String;
    public var tips:String;

    public static function from(obj:Object):ItemData {
        var target:ItemData = new ItemData;
        target.id = obj.id;
        target.targetPids = obj.targetPids == null ? null : Vector.<uint>(obj.targetPids);
        target.name = obj.name;
        target.count = obj.count;
        target.icon = obj.icon;
        target.tips = obj.tips;
        return target;
    }

    public static function clone(obj:ItemData):ItemData {
        var target:ItemData = new ItemData;
        target.id = obj.id;
        target.targetPids = obj.targetPids ? obj.targetPids.concat() : null;
        target.name = obj.name;
        target.count = obj.count;
        target.icon = obj.icon;
        target.tips = obj.tips;
        return target;
    }
}
}
