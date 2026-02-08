package ui {
import flash.display.MovieClip;
import flash.events.Event;

[Embed(source="/assets/UI_Emotion18.swf", symbol="symbol2475")]
public dynamic class IconFallback extends MovieClip {
    public function IconFallback() {
        addEventListener(Event.ADDED_TO_STAGE, onStageAdded);
    }

    private function onStageAdded(e:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, onStageAdded);
        checkAndCorrect();
    }

    private function checkAndCorrect():void {
        try {
            if (transform.concatenatedMatrix.a < 0) {
                // 反转缩放
                this.scaleX *= -1;
                // 调整位置
                this.x += this.width;
            }
        } catch (e:*) {
            //ignore
        }
    }
}
}
