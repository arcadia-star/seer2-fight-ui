package animation.hub {

import animation.event.OperateEvent;

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;


public class FightPointPanel extends Sprite {

    private var _mc:MovieClip;

    private var _prevBtn:SimpleButton;

    private var _nextBtn:SimpleButton;

    private var _contentTxt:TextField;

    private var _textFormat:TextFormat;

    private var _statusList:Vector.<String>;

    private var _currIndex:int;

    private static const SIZE:int = 5;

    public function FightPointPanel(mc:MovieClip) {
        super();
        this._mc = mc;
        this._prevBtn = this._mc["prevBtn"];
        this._nextBtn = this._mc["nextBtn"];
        this._contentTxt = this._mc["contentTxt"];
        this._contentTxt.mouseEnabled = false;
        this._contentTxt.multiline = true;
        this._contentTxt.htmlText = "";
        this._prevBtn.addEventListener(MouseEvent.CLICK, this.onPrev);
        this._nextBtn.addEventListener(MouseEvent.CLICK, this.onNext);
        this._statusList = Vector.<String>([]);
        this._currIndex = 0;
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
