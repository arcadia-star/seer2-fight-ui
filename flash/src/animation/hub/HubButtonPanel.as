package animation.hub {
import animation.event.Events;

import flash.display.DisplayObject;
import flash.display.InteractiveObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

[Embed(source="/_assets/battle-ui.swf", symbol="HubButtonPanel")]
public dynamic class HubButtonPanel extends MovieClip {
    public var hub:MovieClip;

    public static const EVT_FIGHT:String = "fight";

    public static const EVT_ITEM:String = "item";

    public static const EVT_PET:String = "pet";

    public static const EVT_ESCAPE:String = "escape";

    public static const EVT_CATCH:String = "catch";

    private var currentMc:MovieClip;

    public function HubButtonPanel() {
        super();
        this.mouseEnabled = false;
        hub.itemMc.gotoAndStop(1);
        hub.petMc.gotoAndStop(1);
        hub.escapeMc.gotoAndStop(1);
        hub.catchMc.gotoAndStop(1);
        hub.fightBtn.addEventListener(MouseEvent.CLICK, this.onFightClick);
        hub.itemMc.btn.addEventListener(MouseEvent.CLICK, this.onItemClick);
        hub.petMc.btn.addEventListener(MouseEvent.CLICK, this.onPetClick);
        hub.escapeMc.btn.addEventListener(MouseEvent.CLICK, this.onEscapeClick);
        hub.catchMc.btn.addEventListener(MouseEvent.CLICK, this.onCatchClick);
        hub.autoBtn.addEventListener(MouseEvent.CLICK, this.onAutoClick);
        hub.settingBtn.addEventListener(MouseEvent.CLICK, this.onSettingClick);
    }

    public function reset():void {
        this.highLight(null);
    }

    private function onFightClick(param1:MouseEvent):void {
        this.highLight(null);
        dispatchEvent(new Event(EVT_FIGHT));
    }

    private function onItemClick(param1:MouseEvent):void {
        this.highLight(hub.itemMc);
        dispatchEvent(new Event(EVT_ITEM));
    }

    private function onPetClick(param1:MouseEvent):void {
        this.highLight(hub.petMc);
        dispatchEvent(new Event(EVT_PET));
    }

    private function onEscapeClick(param1:MouseEvent):void {
        this.highLight(hub.escapeMc);
        dispatchEvent(new Event(EVT_ESCAPE));
    }

    private function onCatchClick(param1:MouseEvent):void {
        this.highLight(hub.catchMc);
        dispatchEvent(new Event(EVT_CATCH));
    }

    private function onAutoClick(event:MouseEvent):void {
        dispatchEvent(Events.btnAutoClick());
    }

    private function onSettingClick(event:MouseEvent):void {
        dispatchEvent(Events.btnSettingClick());
    }

    private function onMorphClick(event:MouseEvent):void {
        dispatchEvent(Events.btnMorphClick());
    }

    private function highLight(param1:MovieClip):void {
        if (this.currentMc !== param1) {
            if (this.currentMc) {
                this.currentMc.gotoAndStop(1);
            }
            this.currentMc = param1;
            if (this.currentMc) {
                this.currentMc.gotoAndStop(2);
            }
        }
    }

    public function enableHubPanel(able:Boolean):void {
        for (var i:int = 0; i < hub.numChildren; i++) {
            var child:DisplayObject = hub.getChildAt(i);
            if (child == hub.autoBtn) continue;
            if (child == hub.settingBtn) continue;
            if (child is InteractiveObject) {
                InteractiveObject(child).mouseEnabled = able;
            }
            if (child is Sprite) {
                Sprite(child).mouseChildren = able;
            }
        }
    }
}
}
