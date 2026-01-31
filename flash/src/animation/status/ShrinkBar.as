package animation.status {

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;

internal class ShrinkBar extends Sprite {

    protected var _bar:MovieClip;

    protected var _targetFrameNum:int;

    protected var _playDirection:int;

    public function ShrinkBar(param1:MovieClip) {
        super();
        this.mouseEnabled = false;
        this.mouseChildren = false;
        this._bar = param1;
        this._bar.stop();
        addChild(this._bar);
        this.initAtPercent(0);
    }

    public function initAtPercent(param1:Number):void {
        this._targetFrameNum = int(this._bar.totalFrames - param1 * (this._bar.totalFrames - 1));
        if (this._targetFrameNum >= this._bar.totalFrames) {
            this._targetFrameNum = this._bar.totalFrames - 1;
        }
        this._bar.gotoAndStop(this._targetFrameNum);
    }

    public function playToPercent(param1:Number):void {
        this._targetFrameNum = int(this._bar.totalFrames - param1 * (this._bar.totalFrames - 1));
        this.playTo(this._targetFrameNum);
    }

    protected function playTo(param1:int):void {
        this._targetFrameNum = param1;
        if (this._targetFrameNum != this._bar.currentFrame) {
            if (this._targetFrameNum > this._bar.currentFrame) {
                this._playDirection = 1;
            } else {
                this._playDirection = -1;
            }
            this.playBar();
        } else {
            this.stopPlayBar();
        }
    }

    protected function playBar():void {
        addEventListener(Event.ENTER_FRAME, this.onPlay);
    }

    protected function stopPlayBar():void {
        removeEventListener(Event.ENTER_FRAME, this.onPlay);
    }

    private function onPlay(param1:Event):void {
        var _loc2_:int = 0;
        var _loc3_:int = 0;
        if (this._bar != null) {
            _loc2_ = this._bar.currentFrame;
            _loc3_ = _loc2_ + this._playDirection;
            this._bar.gotoAndStop(_loc3_);
            if (_loc3_ == this._targetFrameNum) {
                this.stopPlayBar();
            }
        }
    }

    override public function set width(param1:Number):void {
        this._bar.width = param1;
    }

    override public function get width():Number {
        return this._bar.width;
    }

    override public function set height(param1:Number):void {
        this._bar.height = param1;
    }

    override public function get height():Number {
        return this._bar.height;
    }
}
}
