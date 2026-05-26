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
    public var hitTimeout:int;
    public var hitEventTime:int;//使用监听hit事件触发打击帧时所需数据，手动配置这段动画共有几次hit事件，便于监听的设置销毁与伤害的计算

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
        target.hitTimeout = obj.hitTimeout;
        target.hitEventTime = obj.hitEventTime;
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
        target.hitTimeout = obj.hitTimeout;
        target.hitEventTime = obj.hitEventTime;
        return target;
    }
}
}
