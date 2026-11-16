package animation.hub {
import animation.event.OperateEvent;
import data.pet.PetData;
import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.utils.Dictionary;
import utils.an.DisplayObjectUtil;

internal class FighterPanel {
    private static const MAX_NUM_FIGHTER:int = 6;
    private var _view:MovieClip;
    private var _fighterDisplayVec:Vector.<FighterDisplay> = new Vector.<FighterDisplay>();
    private var _fighters:Dictionary = new Dictionary();
    private var _tip:FighterTip = new FighterTip();
    private var _reviveItem:int;

    public function get view():MovieClip { return _view; }

    public function FighterPanel(view:MovieClip) {
        this._view = view;
        view.mouseEnabled = false;
        for (var i:int = 0; i < MAX_NUM_FIGHTER; i++) {
            var display:FighterDisplay = new FighterDisplay(view["fighter" + i]);
            this._fighterDisplayVec.push(display);
            this._fighters[display.view] = display;
            display.view.addEventListener(MouseEvent.CLICK, onMouseClick);
            display.view.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            display.view.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
        }
    }

    public function initData(pets:Vector.<PetData>):void {
        // 合体、备用变身实体用于战场显示，不是普通换宠候选。
        pets = pets.filter(function(pet:PetData, index:int, all:Vector.<PetData>):Boolean { return !pet.hideInBag; });
        for (var i:int = 0; i < MAX_NUM_FIGHTER; i++) {
            var display:FighterDisplay = this._fighterDisplayVec[i];
            display.view.visible = i < pets.length;
            if (display.view.visible) display.initData(pets[i]);
        }
    }

    public function setReviveItem(item:int):void {
        this._reviveItem = item;
        DisplayObjectUtil.removeFromParent(this._tip);
    }

    private function onMouseOver(event:MouseEvent):void {
        var display:FighterDisplay = this._fighters[event.currentTarget];
        this._tip.x = display.view.x + 15;
        this._tip.y = display.view.y;
        this._tip.initData(display.pet());
        this._view.addChild(this._tip);
    }

    private function onMouseOut(event:MouseEvent):void {
        DisplayObjectUtil.removeFromParent(this._tip);
    }

    private function onMouseClick(event:MouseEvent):void {
        var display:FighterDisplay = this._fighters[event.currentTarget];
        if (this._reviveItem > 0) {
            var pet:PetData = display.pet();
            if (pet.position != 0 || pet.hp > 0) return;
            var item:int = this._reviveItem;
            setReviveItem(0);
            this._view.dispatchEvent(OperateEvent.item(item, pet.pid));
            return;
        }
        this._view.dispatchEvent(OperateEvent.pet(display.pet().pid));
    }
}
}
