package animation.hub {
import animation.event.OperateEvent;
import flash.utils.Dictionary;

import data.pet.ItemData;

import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.display.MovieClip;
import flash.events.MouseEvent;
import utils.an.DisplayObjectUtil;

internal class ItemPanel {
    private var _view:MovieClip;
    private var _items:Dictionary = new Dictionary();
    public function get view():MovieClip { return _view; }

    private static const ITEM_NUM_PAGE:int = 9;

    private var _pageIndex:int;

    private var _maxPageIndex:int;

    private var _petItemVec:Vector.<ItemData>;

    private var _itemDisplayVec:Vector.<ItemDisplay>;

    private var _nextBtn:SimpleButton;

    private var _prevBtn:SimpleButton;

    private var _tip:ItemTip;

    private var _capsule:Boolean;

    public function ItemPanel(capsule:Boolean, view:MovieClip) {
        this._capsule = capsule;
        var i:int = 0;
        var onOver:Function = null;
        var onOut:Function = null;
        var onNextPage:Function = null;
        var onPrevPage:Function = null;
        var itemDisplay:ItemDisplay = null;
        this._view = view;
        onOver = function (param1:MouseEvent):void {
            var _loc2_:ItemDisplay = _items[param1.currentTarget];
            _tip.initData(_loc2_.item());
            _tip.x = _loc2_.view.x + 15;
            _tip.y = _loc2_.view.y;
            _view.addChild(_tip);
        };
        onOut = function (param1:MouseEvent):void {
            DisplayObjectUtil.removeFromParent(_tip);
        };
        onNextPage = function (param1:MouseEvent):void {
            showPage(_pageIndex + 1);
        };
        onPrevPage = function (param1:MouseEvent):void {
            showPage(_pageIndex - 1);
        };
        this._view.mouseEnabled = false;
        this._itemDisplayVec = new Vector.<ItemDisplay>();
        i = 0;
        while (i < ITEM_NUM_PAGE) {
            itemDisplay = new ItemDisplay(_view.getChildByName("item" + i) as MovieClip);
            this._items[itemDisplay.view] = itemDisplay;
            itemDisplay.view.addEventListener(MouseEvent.CLICK, this.onClick);
            itemDisplay.view.addEventListener(MouseEvent.MOUSE_OVER, onOver);
            itemDisplay.view.addEventListener(MouseEvent.MOUSE_OUT, onOut);
            this._itemDisplayVec.push(itemDisplay);
            i++;
        }
        this._prevBtn = _view.getChildByName("prev") as SimpleButton;
        this._nextBtn = _view.getChildByName("next") as SimpleButton;
        this.disableBtn(this._prevBtn);
        this.disableBtn(this._nextBtn);
        this._tip = new ItemTip();
        this._nextBtn.addEventListener(MouseEvent.CLICK, onNextPage);
        this._prevBtn.addEventListener(MouseEvent.CLICK, onPrevPage);
    }

    public function initData(items:Vector.<ItemData>):void {
        this._petItemVec = items;
        this._pageIndex = 0;
        this._maxPageIndex = Math.max(0, Math.floor((this._petItemVec.length - 1) / ITEM_NUM_PAGE));
        this.showPage(this._pageIndex);
    }

    private function showPage(param1:int):void {
        if (param1 < 0 || param1 > _maxPageIndex) {
            return;
        }
        this._pageIndex = param1;
        var start:int = param1 * ITEM_NUM_PAGE;
        var end:Number = Math.min((param1 + 1) * ITEM_NUM_PAGE, _petItemVec.length);
        var items:Vector.<ItemData> = new Vector.<ItemData>();
        for (var i:int = start; i < end; i++) {
            items.push(_petItemVec[i]);
        }
        var count:Number = Math.min(items.length, ITEM_NUM_PAGE);
        for (i = 0; i < count; i++) {
            var display:ItemDisplay = this._itemDisplayVec[i];
            display.initData(items[i]);
        }
        for (i = count; i < ITEM_NUM_PAGE; i++) {
            display = this._itemDisplayVec[i];
            display.initData(null);
        }

        if (param1 > 0) {
            this.enableBtn(this._prevBtn);
        } else {
            this.disableBtn(this._prevBtn);
        }
        if (param1 < this._maxPageIndex) {
            this.enableBtn(this._nextBtn);
        } else {
            this.disableBtn(this._nextBtn);
        }
    }

    private function enableBtn(param1:SimpleButton):void {
        param1.enabled = true;
        param1.mouseEnabled = true;
    }

    private function disableBtn(param1:SimpleButton):void {
        param1.enabled = false;
        param1.mouseEnabled = false;
    }

    private function onClick(param1:MouseEvent):void {
        var itemDisplay:ItemDisplay = _items[param1.currentTarget];
        if (_capsule) {
            this._view.dispatchEvent(OperateEvent.capsule(itemDisplay.item().id));
        } else {
            this._view.dispatchEvent(OperateEvent.item(itemDisplay.item().id));
        }
    }
}
}
