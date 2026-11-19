package animation.hub {
import animation.event.OperateEvent;

import data.pet.ItemData;
import data.pet.PetData;

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.MouseEvent;

import utils.an.DisplayObjectUtil;

[Embed(source="/_assets/battle-ui.swf", symbol="FighterPanel")]
public dynamic class FighterPanel extends MovieClip {
    public var fighter0:FighterDisplay;
    public var fighter1:FighterDisplay;
    public var fighter2:FighterDisplay;
    public var fighter3:FighterDisplay;
    public var fighter4:FighterDisplay;
    public var fighter5:FighterDisplay;
    private var _fighterDisplayVec:Vector.<FighterDisplay>;
    public var prev:SimpleButton;
    public var next:SimpleButton;
    private var _pets:Vector.<PetData>;
    private var _page:int;
    private var _tip:FighterTip = new FighterTip();
    private var _targetItem:ItemData;

    public function FighterPanel() {
        mouseEnabled = false;
        _fighterDisplayVec = new <FighterDisplay>[fighter0, fighter1, fighter2, fighter3, fighter4, fighter5];
        for each (var display:FighterDisplay in _fighterDisplayVec) {
            display.addEventListener(MouseEvent.CLICK, onMouseClick);
            display.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            display.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
        }
        prev.visible = next.visible = false;
        prev.addEventListener(MouseEvent.CLICK, function (event:MouseEvent):void {
            showPage(_page - 1);
        });
        next.addEventListener(MouseEvent.CLICK, function (event:MouseEvent):void {
            showPage(_page + 1);
        });
    }

    public function initData(pets:Vector.<PetData>):void {
        _pets = pets;
        showPage(0);
    }

    private function showPage(page:int):void {
        var start:int = page * _fighterDisplayVec.length;
        if (page < 0 || (page > 0 && start >= _pets.length)) return;

        DisplayObjectUtil.removeFromParent(_tip);
        _page = page;
        for (var i:int = 0; i < _fighterDisplayVec.length; i++) {
            var display:FighterDisplay = _fighterDisplayVec[i];
            var index:int = start + i;
            display.visible = index < _pets.length;
            if (display.visible) display.initData(_pets[index]);
        }
        prev.visible = next.visible = _pets.length > _fighterDisplayVec.length;
        prev.enabled = prev.mouseEnabled = page > 0;
        next.enabled = next.mouseEnabled = start + _fighterDisplayVec.length < _pets.length;
    }

    public function setTargetItem(item:ItemData):void {
        this._targetItem = item;
        DisplayObjectUtil.removeFromParent(this._tip);
    }

    private function onMouseOver(event:MouseEvent):void {
        var display:FighterDisplay = FighterDisplay(event.currentTarget);
        this._tip.x = display.x + 15;
        this._tip.y = display.y;
        this._tip.initData(display.pet());
        this.addChild(this._tip);
    }

    private function onMouseOut(event:MouseEvent):void {
        DisplayObjectUtil.removeFromParent(this._tip);
    }

    private function onMouseClick(event:MouseEvent):void {
        var display:FighterDisplay = FighterDisplay(event.currentTarget);
        var pid:uint = display.pet().pid;
        if (this._targetItem) {
            if (this._targetItem.targetPids.indexOf(pid) < 0) return;
            var item:int = this._targetItem.id;
            setTargetItem(null);
            this.dispatchEvent(OperateEvent.item(item, pid));
            return;
        }
        this.dispatchEvent(OperateEvent.pet(pid));
    }
}
}
