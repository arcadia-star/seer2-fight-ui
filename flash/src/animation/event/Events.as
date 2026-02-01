package animation.event {
import flash.events.Event;

public class Events {
    public static const ALERT_END:String = "alertEnd";
    public static const ANIMATION_END:String = "animationEnd";
    public static const BTN_MORPH_CLICK:String = "btnMorphClick";
    public static const FRAME_PLAY_END:String = "framePlayEnd";
    public static const FRAME_MOVE_HIT:String = "frameMoveHit";

    public static function alertEnd():Event {
        return new Event(Events.ALERT_END);
    }

    public static function animationEnd():Event {
        return new Event(Events.ANIMATION_END);
    }

    public static function btnMorphClick():Event {
        return new Event(Events.BTN_MORPH_CLICK, true);
    }

    public static function framePlayEnd():Event {
        return new Event(Events.FRAME_PLAY_END);
    }

    public static function frameMoveHit():Event {
        return new Event(Events.FRAME_MOVE_HIT);
    }
}
}
