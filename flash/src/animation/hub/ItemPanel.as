package animation.hub {
import animation.event.OperateEvent;

import data.pet.ItemData;

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.MouseEvent;

import utils.an.DisplayObjectUtil;

[Embed(source="/_assets/battle-ui.swf", symbol="ItemPanel")]
public dynamic class ItemPanel extends MovieClip {
    public var item0:ItemDisplay;
    public var item1:ItemDisplay;
    public var item2:ItemDisplay;
    public var item3:ItemDisplay;
    public var item4:ItemDisplay;
    public var item5:ItemDisplay;
    public var item6:ItemDisplay;
    public var item7:ItemDisplay;
    public var item8:ItemDisplay;
    public var prev:SimpleButton;
    public var next:SimpleButton;

    private var _pageIndex:int;
    private var _items:Vector.<ItemData>;
    private var _slots:Vector.<ItemDisplay>;
    private var _tip:ItemTip;

    private var _capsule:Boolean;
    private var _selectTarget:Function;

    public function ItemPanel() {
        mouseEnabled = false;
        _tip = new ItemTip();
        _slots = new <ItemDisplay>[item0, item1, item2, item3, item4, item5, item6, item7, item8];
        for each (var item:ItemDisplay in _slots) {
            item.addEventListener(MouseEvent.CLICK, onClick);
            item.addEventListener(MouseEvent.MOUSE_OVER, onOver);
            item.addEventListener(MouseEvent.MOUSE_OUT, onOut);
        }
        setButtonEnabled(prev, false);
        setButtonEnabled(next, false);
        next.addEventListener(MouseEvent.CLICK, function (event:MouseEvent):void {
            showPage(_pageIndex + 1);
        });
        prev.addEventListener(MouseEvent.CLICK, function (event:MouseEvent):void {
            showPage(_pageIndex - 1);
        });
    }

    internal function configure(capsule:Boolean, selectTarget:Function = null):void {
        _capsule = capsule;
        _selectTarget = selectTarget;
    }

    private function onOver(event:MouseEvent):void {
        var item:ItemDisplay = ItemDisplay(event.currentTarget);
        _tip.initData(item.item());
        _tip.x = item.x + 15;
        _tip.y = item.y;
        addChild(_tip);
    }

    private function onOut(event:MouseEvent):void {
        DisplayObjectUtil.removeFromParent(_tip);
    }

    public function initData(items:Vector.<ItemData>):void {
        _items = items;
        showPage(0);
    }

    private function showPage(page:int):void {
        var start:int = page * _slots.length;
        if (page < 0 || (page > 0 && start >= _items.length)) return;

        _pageIndex = page;
        for (var i:int = 0; i < _slots.length; i++) {
            var index:int = start + i;
            _slots[i].initData(index < _items.length ? _items[index] : null);
        }
        setButtonEnabled(prev, page > 0);
        setButtonEnabled(next, start + _slots.length < _items.length);
    }

    private function setButtonEnabled(button:SimpleButton, enabled:Boolean):void {
        button.enabled = button.mouseEnabled = enabled;
    }

    private function onClick(param1:MouseEvent):void {
        var itemDisplay:ItemDisplay = ItemDisplay(param1.currentTarget);
        var item:ItemData = itemDisplay.item();
        if (_capsule) {
            this.dispatchEvent(OperateEvent.capsule(item.id));
        } else if (item.targetPids) {
            this._selectTarget(item);
        } else {
            this.dispatchEvent(OperateEvent.item(item.id));
        }
    }
}
}
