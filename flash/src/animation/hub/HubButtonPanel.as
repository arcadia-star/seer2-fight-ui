package animation.hub {
import animation.event.Events;

import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import ui.hub.New_UI_FightPet;
import ui.hub.UI_FightCatch;
import ui.hub.UI_FightEscape;
import ui.hub.UI_FightFight;
import ui.hub.UI_FightHighCatch;
import ui.hub.UI_FightHighEscape;
import ui.hub.UI_FightHighFight;
import ui.hub.UI_FightHighItem;
import ui.hub.UI_FightHighPet;
import ui.hub.UI_FightItem;
import ui.hub.UI_FightPet;

internal class HubButtonPanel extends Sprite {

    public static const EVT_FIGHT:String = "fight";

    public static const EVT_ITEM:String = "item";

    public static const EVT_PET:String = "pet";

    public static const EVT_ESCAPE:String = "escape";

    public static const EVT_CATCH:String = "catch";

    private var _fightBtn:SimpleButton;

    private var _itemBtn:SimpleButton;

    private var _petBtn:SimpleButton;

    private var _escapeBtn:SimpleButton;

    private var _catchBtn:SimpleButton;

    private var _fightHighlight:Sprite;

    private var _itemHighlight:Sprite;

    private var _petHighlight:Sprite;

    private var _escapeHighlight:Sprite;

    private var _catchHighlight:Sprite;

    private var currentBtn:SimpleButton;
    private var currentHighLight:Sprite;

    private var _morphBtn:SimpleButton;

    public function HubButtonPanel() {
        super();
        this.mouseEnabled = false;
        this._fightBtn = new UI_FightFight;
        this._fightHighlight = new UI_FightHighFight;
        this._fightHighlight.x = this._fightBtn.x = 780;
        this._fightHighlight.y = this._fightBtn.y = 74;
        this._fightHighlight.mouseChildren = false;
        this._fightHighlight.mouseEnabled = false;
        addChild(this._fightBtn);
        this._itemBtn = new UI_FightItem;
        this._itemHighlight = new UI_FightHighItem;
        this._itemHighlight.mouseChildren = false;
        this._itemHighlight.mouseEnabled = false;
        this._itemHighlight.x = this._itemBtn.x = 778;
        this._itemHighlight.y = this._itemBtn.y = 114;
        addChild(this._itemBtn);
        this._petBtn = new UI_FightPet;
        this._petHighlight = new UI_FightHighPet;
        this._petHighlight.x = this._petBtn.x = 778;
        this._petHighlight.y = this._petBtn.y = 41;
        this._petHighlight.mouseChildren = false;
        this._petHighlight.mouseEnabled = false;
        addChild(this._petBtn);
        this._escapeBtn = new UI_FightEscape;
        this._escapeHighlight = new UI_FightHighEscape;
        this._escapeHighlight.x = this._escapeBtn.x = 871;
        this._escapeHighlight.y = this._escapeBtn.y = 114;
        this._escapeHighlight.mouseChildren = false;
        this._escapeHighlight.mouseEnabled = false;
        addChild(this._escapeBtn);
        this._catchBtn = new UI_FightCatch;
        this._catchHighlight = new UI_FightHighCatch;
        this._catchHighlight.x = this._catchBtn.x = 871;
        this._catchHighlight.y = this._catchBtn.y = 41;
        addChild(this._catchBtn);
        this._fightBtn.addEventListener(MouseEvent.CLICK, this.onFightClick);
        this._itemBtn.addEventListener(MouseEvent.CLICK, this.onItemClick);
        this._petBtn.addEventListener(MouseEvent.CLICK, this.onPetClick);
        this._escapeBtn.addEventListener(MouseEvent.CLICK, this.onEscapeClick);
        this._catchBtn.addEventListener(MouseEvent.CLICK, this.onCatchClick);
        this._morphBtn = new New_UI_FightPet;
        _morphBtn.x = 870;
        _morphBtn.y = -50;
        addChild(_morphBtn);
        _morphBtn.addEventListener(MouseEvent.CLICK, this.onMorphClick);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemoved);
    }

    private function onRemoved(param1:Event):void {
        removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemoved);
        _fightBtn.removeEventListener(MouseEvent.CLICK, this.onFightClick);
        _itemBtn.removeEventListener(MouseEvent.CLICK, this.onItemClick);
        _petBtn.removeEventListener(MouseEvent.CLICK, this.onPetClick);
        _escapeBtn.removeEventListener(MouseEvent.CLICK, this.onEscapeClick);
        _catchBtn.removeEventListener(MouseEvent.CLICK, this.onCatchClick);
        _morphBtn.removeEventListener(MouseEvent.CLICK, this.onMorphClick);
    }

    public function reset():void {
        this.highLight(null, null);
    }

    private function onFightClick(param1:MouseEvent):void {
        this.highLight(null, null);
        dispatchEvent(new Event(EVT_FIGHT));
    }

    private function onItemClick(param1:MouseEvent):void {
        this.highLight(this._itemBtn, this._itemHighlight);
        dispatchEvent(new Event(EVT_ITEM));
    }

    private function onPetClick(param1:MouseEvent):void {
        this.highLight(this._petBtn, this._petHighlight);
        dispatchEvent(new Event(EVT_PET));
    }

    private function onEscapeClick(param1:MouseEvent):void {
        this.highLight(this._escapeBtn, _escapeHighlight);
        dispatchEvent(new Event(EVT_ESCAPE));
    }

    private function onCatchClick(param1:MouseEvent):void {
        this.highLight(this._catchBtn, this._catchHighlight);
        dispatchEvent(new Event(EVT_CATCH));
    }

    private function onMorphClick(event:MouseEvent):void {
        dispatchEvent(Events.btnMorphClick());
    }

    private function highLight(param1:SimpleButton, param2:Sprite):void {
        if (currentBtn !== param1) {
            if (currentBtn) {
                currentBtn.scaleX = currentBtn.scaleY = 1;
            }
            currentBtn = param1;
            if (currentBtn) {
                currentBtn.scaleX = currentBtn.scaleY = 0;
            }
        }
        if (currentHighLight !== param2) {
            if (currentHighLight && currentHighLight.parent) {
                removeChild(currentHighLight);
            }
            currentHighLight = param2;
            if (currentHighLight && currentHighLight) {
                addChild(currentHighLight);
            }
        }
    }
}
}
