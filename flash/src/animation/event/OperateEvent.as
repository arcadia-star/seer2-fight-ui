package animation.event {
import data.operate.OperateData;

import flash.events.Event;

public class OperateEvent extends Event {

    public static const OPERATE_END:String = "operateEnd";

    public var data:OperateData;

    public function OperateEvent(param1:String) {
        super(param1, true, true);
        this.data = new OperateData();
    }

    public static function skill(skill:int):OperateEvent {
        var event:OperateEvent = new OperateEvent(OPERATE_END);
        event.data.skill = skill;
        return event;
    }

    public static function pet(pet:int):OperateEvent {
        var event:OperateEvent = new OperateEvent(OPERATE_END);
        event.data.pet = pet;
        return event;
    }

    public static function item(item:int):OperateEvent {
        var event:OperateEvent = new OperateEvent(OPERATE_END);
        event.data.item = item;
        return event;
    }

    public static function capsule(capsule:int):OperateEvent {
        var event:OperateEvent = new OperateEvent(OPERATE_END);
        event.data.capsule = capsule;
        return event;
    }

    public static function escape(escape:int):OperateEvent {
        var event:OperateEvent = new OperateEvent(OPERATE_END);
        event.data.escape = escape;
        return event;
    }

    public static function changeUI():OperateEvent {
        var event:OperateEvent = new OperateEvent(OPERATE_END);
        event.data.functional = OperateData.FUNCTIONAL_CHANGE_UI;
        return event;
    }
}
}
