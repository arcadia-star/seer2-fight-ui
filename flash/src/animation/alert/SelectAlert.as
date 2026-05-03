package animation.alert {
import animation.common.*;
import animation.event.Events;

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;

import ui.common.UI_SelectPet;

import utils.an.DisplayObjectUtil;
import utils.an.MotionEffects;

public class SelectAlert extends Sprite {
    private var _ui:MovieClip;

    private var _tipTxt:TextField;

    private var _cells:Vector.<MovieClip>;

    private var _confirmBtn:SimpleButton;

    private var _cancelBtn:SimpleButton;

    private var _confirmHandler:Function;

    private var _cancelHandler:Function;

    private var _items:Array;

    private var _item:*;

    private static const SIZE:int = 6;

    public function SelectAlert() {
        this._ui = new UI_SelectPet;
        this._tipTxt = _ui.tipTxt;
        this._cells = new Vector.<MovieClip>();
        this._confirmBtn = _ui["confirmBtn"];
        this._cancelBtn = _ui["cancelBtn"];
        for (var i:int = 0; i < SIZE; i++) {
            var cell:MovieClip = _ui["cell_" + i] as MovieClip;
            this._cells.push(cell);
            DisplayObjectUtil.removeFromParent(cell["levelBg"]);
            DisplayObjectUtil.removeFromParent(cell["levelTxt"]);
            DisplayObjectUtil.removeFromParent(cell["studyTxt"]);
            DisplayObjectUtil.removeFromParent(cell["studyLabel"]);
            (cell["light"] as MovieClip).gotoAndStop(0);
            (cell["selector"] as MovieClip).visible = false;
            cell.buttonMode = true;
            cell.addEventListener(MouseEvent.CLICK, this.onMouseCell);
            cell.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            cell.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
            cell.mouseChildren = false;
            cell.mouseEnabled = false;
            var icon:IconDisplay = new IconDisplay();
            icon.x = icon.y = -40;
            icon.setSize(84);
            cell.addChildAt(icon, 1);
            var text:TextField = new TextField();
            text.defaultTextFormat = new TextFormat("_sans", 14);
            text.textColor = 0xffffff;
            text.x = -40;
            text.y = 50;
            cell.addChildAt(text, 2);
        }
        DisplayObjectUtil.disableButton(this._confirmBtn);
        this._confirmBtn.addEventListener(MouseEvent.CLICK, this.okBtn);
        this._cancelBtn.addEventListener(MouseEvent.CLICK, this.onCancelBtnClick);
        addChild(_ui);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemoved);
    }

    private function onRemoved(param1:Event):void {
        removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemoved);
        _confirmBtn.removeEventListener(MouseEvent.CLICK, this.okBtn);
        _cancelBtn.removeEventListener(MouseEvent.CLICK, this.onCancelBtnClick);
        for (var i:int = 0; i < SIZE; i++) {
            var cell:MovieClip = _cells[i];
            cell.removeEventListener(MouseEvent.CLICK, this.onMouseCell);
            cell.removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            cell.removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        }
    }

    private function okBtn(param1:MouseEvent):void {
        if (this._item != null) {
            DisplayObjectUtil.disableButton(this._confirmBtn);
            if (this._confirmHandler != null) {
                this._confirmHandler(this._item);
            }
        }
        param1.stopImmediatePropagation();
        dispatchEvent(Events.alertEnd());
    }

    private function onCancelBtnClick(param1:MouseEvent):void {
        if (this._cancelHandler != null) {
            this._cancelHandler();
        }
        param1.stopImmediatePropagation();
        dispatchEvent(Events.alertEnd());
    }

    private function onMouseCell(param1:MouseEvent):void {
        DisplayObjectUtil.enableButton(this._confirmBtn);
        var _loc2_:MovieClip = param1.currentTarget as MovieClip;
        for (var i:int = 0; i < SIZE; i++) {
            var cell:MovieClip = _cells[i];
            if (cell === _loc2_) {
                cell["selector"].visible = true;
                this._item = _items[i];
            } else {
                cell["selector"].visible = false;
            }
        }
    }

    private function onMouseOver(param1:MouseEvent):void {
        var _loc2_:MovieClip = param1.currentTarget as MovieClip;
        var _curtLight:MovieClip = _loc2_["light"] as MovieClip;
        _curtLight.gotoAndPlay(0);
        MotionEffects.execElastic(_loc2_);
    }

    private function onMouseOut(param1:MouseEvent):void {
        var _loc2_:MovieClip = param1.currentTarget as MovieClip;
        var _curtLight:MovieClip = _loc2_["light"] as MovieClip;
        _curtLight.gotoAndStop(0);
        MotionEffects.resetScale(_loc2_);
    }

    public function initData(message:String, items:Array, confirm:Function = null, cancel:Function = null):void {
        this._tipTxt.htmlText = message;
        this._items = items;
        this._confirmHandler = confirm;
        this._cancelHandler = cancel;
        var idx:uint;
        var len:uint = Math.min(this._items.length, SIZE);
        for (idx = 0; idx < len; idx++) {
            var item:* = this._items[idx];
            var cell:MovieClip = _cells[idx];
            (cell.getChildAt(1) as IconDisplay).initData(item.url);
            (cell.getChildAt(2) as TextField).text = item.name;
            cell.mouseEnabled = true;
        }
    }
}
}
