package animation.alert {
import animation.event.Events;

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;

import ui.common.UI_Confirm;

public class ConfirmAlert extends Sprite {
    private var _ui:MovieClip;
    private var _confirmBtn:SimpleButton;
    private var _cancelBtn:SimpleButton;
    private var _contentTxt:TextField;
    private var _confirmHandler:Function;
    private var _cancelHandler:Function;

    public function ConfirmAlert() {
        this.mouseEnabled = false;
        this._ui = new UI_Confirm;
        this._confirmBtn = this._ui["confirmBtn"];
        this._confirmBtn.addEventListener(MouseEvent.CLICK, this.onConfirmBtnClick);
        this._cancelBtn = this._ui["cancelBtn"];
        this._cancelBtn.addEventListener(MouseEvent.CLICK, this.onCancelBtnClick);
        this._contentTxt = this._ui["contentTxt"];
        addChild(this._ui);
    }

    private function onConfirmBtnClick(param1:MouseEvent):void {
        if (this._confirmHandler != null) {
            this._confirmHandler();
            this._confirmHandler = null;
        }
        param1.stopImmediatePropagation();
        dispatchEvent(Events.alertEnd());
    }

    private function onCancelBtnClick(param1:MouseEvent):void {
        if (this._cancelHandler != null) {
            this._cancelHandler();
            this._cancelHandler = null;
        }
        param1.stopImmediatePropagation();
        dispatchEvent(Events.alertEnd());
    }

    public function initData(message:String, confirm:Function, cancel:Function = null):void {
        this._contentTxt.htmlText = message;
        this._confirmHandler = confirm;
        this._cancelHandler = cancel;
    }
}
}
