package animation.hub {
import animation.event.Events;
import flash.events.EventDispatcher;

import flash.display.DisplayObject;
import flash.display.InteractiveObject;

import flash.display.MovieClip;

import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

internal class HubButtonPanel extends EventDispatcher {

    private var _view:MovieClip;
    public function get view():MovieClip { return _view; }

    public static const EVT_FIGHT:String = "fight";

    public static const EVT_ITEM:String = "item";

    public static const EVT_PET:String = "pet";

    public static const EVT_ESCAPE:String = "escape";

    public static const EVT_CATCH:String = "catch";

    private var _fightBtn:SimpleButton;

    private var _autoBtn:SimpleButton;

    private var _settingBtn:SimpleButton;

    private var _itemBtn:SimpleButton;

    private var _petBtn:SimpleButton;

    private var _escapeBtn:SimpleButton;

    private var _catchBtn:SimpleButton;

    private var _itemMc:MovieClip;

    private var _petMc:MovieClip;

    private var _escapeMc:MovieClip;

    private var _catchMc:MovieClip;

    private var currentMc:MovieClip;

    private var _hub:MovieClip;


    public function HubButtonPanel(view:MovieClip) {
        super();
        this._view = view;
        this._view.mouseEnabled = false;
        this._hub = _view.getChildByName("hub") as MovieClip;
        this._fightBtn = this._hub["fightBtn"];
        this._autoBtn = this._hub["autoBtn"];
        this._settingBtn = this._hub["settingBtn"];
        this._itemMc = this._hub["itemMc"];
        this._itemMc.gotoAndStop(1);
        this._itemBtn = this._itemMc["btn"];
        this._petMc = this._hub["petMc"];
        this._petMc.gotoAndStop(1);
        this._petBtn = this._petMc["btn"];
        this._escapeMc = this._hub["escapeMc"];
        this._escapeMc.gotoAndStop(1);
        this._escapeBtn = this._escapeMc["btn"];
        this._catchMc = this._hub["catchMc"];
        this._catchMc.gotoAndStop(1);
        this._catchBtn = this._catchMc["btn"];
        this._fightBtn.addEventListener(MouseEvent.CLICK, this.onFightClick);
        this._itemBtn.addEventListener(MouseEvent.CLICK, this.onItemClick);
        this._petBtn.addEventListener(MouseEvent.CLICK, this.onPetClick);
        this._escapeBtn.addEventListener(MouseEvent.CLICK, this.onEscapeClick);
        this._catchBtn.addEventListener(MouseEvent.CLICK, this.onCatchClick);
        this._autoBtn.addEventListener(MouseEvent.CLICK, this.onAutoClick);
        this._settingBtn.addEventListener(MouseEvent.CLICK, this.onSettingClick);
    }

    public function reset():void {
        this.highLight(null);
    }

    private function onFightClick(param1:MouseEvent):void {
        this.highLight(null);
        dispatchEvent(new Event(EVT_FIGHT));
    }

    private function onItemClick(param1:MouseEvent):void {
        this.highLight(this._itemMc);
        dispatchEvent(new Event(EVT_ITEM));
    }

    private function onPetClick(param1:MouseEvent):void {
        this.highLight(this._petMc);
        dispatchEvent(new Event(EVT_PET));
    }

    private function onEscapeClick(param1:MouseEvent):void {
        this.highLight(this._escapeMc);
        dispatchEvent(new Event(EVT_ESCAPE));
    }

    private function onCatchClick(param1:MouseEvent):void {
        this.highLight(this._catchMc);
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
        for(var i:int = 0; i < this._hub.numChildren; i++) {
            var child:DisplayObject = this._hub.getChildAt(i);
            if(child == this._autoBtn) continue;
            if(child == this._settingBtn) continue;
            if(child is InteractiveObject) {
                InteractiveObject(child).mouseEnabled = able;
            }
            if(child is Sprite) {
                Sprite(child).mouseChildren = able;
            }
        }
    }
}
}
