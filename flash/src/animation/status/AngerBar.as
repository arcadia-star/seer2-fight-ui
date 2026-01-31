package animation.status {
import flash.display.MovieClip;

internal class AngerBar extends ShrinkBar {


    private var _percents:Array;

    private var _playingFlag:Boolean = false;

    public function AngerBar(param1:MovieClip) {
        this._percents = [];
        super(param1);
    }

    override public function initAtPercent(param1:Number):void {
        _bar.gotoAndStop(int(_bar.totalFrames - param1 * (_bar.totalFrames - 1)));
    }

    override public function playToPercent(param1:Number):void {
        this._percents.push(int(_bar.totalFrames - param1 * (_bar.totalFrames - 1)));
        this.startPlay();
    }

    override protected function stopPlayBar():void {
        super.stopPlayBar();
        this._playingFlag = false;
        this.startPlay();
    }

    private function startPlay():void {
        if (!this._playingFlag && this._percents && this._percents.length > 0) {
            _targetFrameNum = this._percents.splice(0, 1)[0];
            this._playingFlag = true;
            playTo(_targetFrameNum);
        }
    }
}
}
