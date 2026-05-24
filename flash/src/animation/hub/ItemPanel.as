package animation.hub {
import animation.event.OperateEvent;

import data.pet.ItemData;

import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.MouseEvent;

import ui.hub.UI_FightPage;

internal class ItemPanel extends Sprite {

    private static const ITEM_NUM_PAGE:int = 9;

    private var _pageIndex:int;

    private var _maxPageIndex:int;

    private var _petItemVec:Vector.<ItemData>;

    private var _itemDisplayVec:Vector.<ItemDisplay>;

    private var _nextBtn:SimpleButton;

    private var _prevBtn:SimpleButton;

    private var _tip:ItemTip;

    private var _capsule:Boolean;

    public function ItemPanel(capsule:Boolean) {
        this._capsule = capsule;
        var offsetX:int;
        var offsetY:int;
        var itemWidth:int;
        var i:int = 0;
        var onOver:Function = null;
        var onOut:Function = null;
        var onNextPage:Function = null;
        var onPrevPage:Function = null;
        var itemDisplay:ItemDisplay = null;
        super();
        onOver = function (param1:MouseEvent):void {
            var _loc2_:ItemDisplay = param1.currentTarget as ItemDisplay;
            _tip.initData(_loc2_.item());
            _tip.x = _loc2_.x + 15;
            _tip.y = _loc2_.y;
            addChild(_tip);
        };
        onOut = function (param1:MouseEvent):void {
            if (Boolean(_tip) && contains(_tip)) {
                removeChild(_tip);
            }
        };
        onNextPage = function (param1:MouseEvent):void {
            showPage(_pageIndex + 1);
        };
        onPrevPage = function (param1:MouseEvent):void {
            showPage(_pageIndex - 1);
        };
        this.mouseEnabled = false;
        offsetX = 28;
        offsetY = 7;
        itemWidth = 73;
        this._itemDisplayVec = new Vector.<ItemDisplay>();
        i = 0;
        while (i < ITEM_NUM_PAGE) {
            itemDisplay = new ItemDisplay();
            itemDisplay.x = offsetX + i * itemWidth;
            itemDisplay.y = offsetY + i % 2 * 20;
            itemDisplay.addEventListener(MouseEvent.CLICK, this.onClick);
            itemDisplay.addEventListener(MouseEvent.MOUSE_OVER, onOver);
            itemDisplay.addEventListener(MouseEvent.MOUSE_OUT, onOut);
            this._itemDisplayVec.push(itemDisplay);
            addChild(itemDisplay);
            i++;
        }
        this._prevBtn = new UI_FightPage;
        this._prevBtn.x = 3;
        this._prevBtn.y = 60;
        addChild(this._prevBtn);
        this._nextBtn = new UI_FightPage;
        this._nextBtn.x = 693;
        this._nextBtn.y = 47;
        this._nextBtn.scaleX = -1;
        addChild(this._nextBtn);
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
        var count:Number = Math.min(end - start, ITEM_NUM_PAGE);
        for (var i:int = 0; i < count; i++) {
            var display:ItemDisplay = this._itemDisplayVec[i];
            display.initData(_petItemVec[start + i]);
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
        var itemDisplay:ItemDisplay = param1.currentTarget as ItemDisplay;
        if (_capsule) {
            dispatchEvent(OperateEvent.capsule(itemDisplay.item().id));
        } else {
            dispatchEvent(OperateEvent.item(itemDisplay.item().id));
        }
    }
}
}
