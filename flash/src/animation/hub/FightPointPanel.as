package animation.hub {

import animation.event.OperateEvent;

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;

import ui.hub.New_UI_Fight_Poing;

public class FightPointPanel extends Sprite {

    private var _mc:MovieClip;

    private var _changFightUIBtn:SimpleButton;

    private var _prevBtn:SimpleButton;

    private var _nextBtn:SimpleButton;

    private var _contentTxt:TextField;

    private var _textFormat:TextFormat;

    private var _statusList:Vector.<String>;

    private var _currIndex:int;

    private static const SIZE:int = 5;

    public function FightPointPanel() {
        super();
        this._mc = new New_UI_Fight_Poing;
        this._changFightUIBtn = this._mc["changFightUIBtn"];
        this._prevBtn = this._mc["prevBtn"];
        this._nextBtn = this._mc["nextBtn"];
        this._contentTxt = new TextField();
        this._contentTxt.x = 22;
        this._contentTxt.y = 25;
        this._mc.addChild(this._contentTxt);
        this._contentTxt.width = 200;
        this._contentTxt.mouseEnabled = false;
        this._contentTxt.multiline = true;
        this._contentTxt.htmlText = "";
        this._contentTxt.defaultTextFormat = new TextFormat("_sans", 14);
        this._changFightUIBtn.addEventListener(MouseEvent.CLICK, this.onChangFightUI);
        this._prevBtn.addEventListener(MouseEvent.CLICK, this.onPrev);
        this._nextBtn.addEventListener(MouseEvent.CLICK, this.onNext);
        this._statusList = Vector.<String>([]);
        this._currIndex = 0;
        addChild(this._mc);
    }

    private function updateStatus(param1:Vector.<String>):void {
        var _loc2_:int = 0;
        this._contentTxt.htmlText = "";
        if (param1.length < SIZE) {
            param1.unshift(" ");
            this.updateStatus(param1);
        } else {
            _loc2_ = 0;
            while (_loc2_ < SIZE) {
                if (_loc2_ < SIZE - 1) {
                    this._contentTxt.htmlText += param1[_loc2_] + "\n";
                } else {
                    this._contentTxt.htmlText += param1[_loc2_];
                }
                _loc2_++;
            }
        }
    }

    private function onChangFightUI(param1:MouseEvent):void {
        dispatchEvent(OperateEvent.changeUI())
    }

    private function onPrev(param1:MouseEvent):void {
        var _loc2_:int = 0;
        if (this._statusList.length > this._currIndex + SIZE) {
            ++this._currIndex;
            _loc2_ = this._statusList.length - (this._currIndex + SIZE);
            this.updateStatus(this._statusList.slice(_loc2_, _loc2_ + SIZE));
        }
    }

    private function onNext(param1:MouseEvent):void {
        var _loc2_:int = 0;
        if (this._currIndex > 0) {
            --this._currIndex;
            _loc2_ = this._statusList.length - (this._currIndex + SIZE);
            this.updateStatus(this._statusList.slice(_loc2_, _loc2_ + SIZE));
        }
    }

    public function entryValue(param1:Vector.<String>):void {
        if (!param1) {
            return;
        }
        for (var i:int = 0; i < param1.length; i++) {
            this._statusList.push(param1[i]);
        }
        this._currIndex = 0;
        if (this._statusList.length < SIZE) {
            this.updateStatus(this._statusList);
        } else {
            this.updateStatus(this._statusList.slice(this._statusList.length - SIZE, this._statusList.length));
        }
    }

}
}
