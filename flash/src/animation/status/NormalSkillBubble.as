package animation.status {
import com.greensock.TweenLite;
import com.greensock.easing.Strong;
import flash.display.MovieClip;
import flash.text.TextField;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;
import utils.an.DisplayObjectUtil;

internal class NormalSkillBubble {
    private var _view:MovieClip;
    private var _bubble:MovieClip;
    private var _skillNameTxt:TextField;
    private var _bubbleContent:String;
    private var _hideTimer:uint;
    public function NormalSkillBubble(view:MovieClip) {
        _view=view;_bubble=view["bubble"];_skillNameTxt=_bubble["skillNameTxt"];
        DisplayObjectUtil.disableSprite(view);
    }
    public function setSkillName(param1:String):void {
        this._bubbleContent = param1;
        this._skillNameTxt.text = this._bubbleContent;
        this.emerge();
    }

    private function emerge():void {
        clearTimeout(this._hideTimer);
        TweenLite.killTweensOf(this._view);
        this._view.visible = true;
        TweenLite.to(this._view, 0.5, {
            "alpha": 1,
            "ease": Strong.easeIn,
            "onComplete": this.onEmerge
        });
    }

    private function onEmerge():void {
        this._skillNameTxt.text = this._bubbleContent;
        this._hideTimer = setTimeout(this.shrink, 2000);
    }

    private function shrink():void {
        TweenLite.to(this._view, 0.5, {
            "alpha": 0,
            "ease": Strong.easeIn,
            "onComplete": this.onComplete
        });
    }

    private function onComplete():void {
        if (this) {
            this._view.visible = false;
        }
    }
}
}
