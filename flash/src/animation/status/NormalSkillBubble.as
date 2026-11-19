package animation.status {
import com.greensock.TweenLite;
import com.greensock.easing.Strong;

import flash.display.MovieClip;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import utils.an.DisplayObjectUtil;

public dynamic class NormalSkillBubble extends MovieClip {
    public var bubble:MovieClip;
    private var _hideTimer:uint;

    public function NormalSkillBubble() {
        DisplayObjectUtil.disableSprite(this);
    }

    public function setSkillName(param1:String):void {
        bubble.skillNameTxt.text = param1;
        this.emerge();
    }

    private function emerge():void {
        clearTimeout(this._hideTimer);
        TweenLite.killTweensOf(this);
        this.visible = true;
        TweenLite.to(this, 0.5, {
            "alpha": 1,
            "ease": Strong.easeIn,
            "onComplete": this.onEmerge
        });
    }

    private function onEmerge():void {
        this._hideTimer = setTimeout(this.shrink, 2000);
    }

    private function shrink():void {
        TweenLite.to(this, 0.5, {
            "alpha": 0,
            "ease": Strong.easeIn,
            "onComplete": this.onComplete
        });
    }

    private function onComplete():void {
        visible = false;
    }
}
}
