package animation.status {
import com.greensock.TweenLite;
import com.greensock.easing.Strong;

import enums.FightSide;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextField;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import ui.status.UI_FightSkillLeftBubble;
import ui.status.UI_FightSkillRightBubble;

import utils.an.DisplayObjectUtil;

internal class SkillBubble extends Sprite {

    private var _side:uint;

    private var _bubble:MovieClip;

    private var _skillNameTxt:TextField;

    private var _bubbleContent:String;

    public function SkillBubble(param1:uint) {
        super();
        this._side = param1;
        DisplayObjectUtil.disableSprite(this);
        this._bubble = this._side == FightSide.LEFT ? new UI_FightSkillLeftBubble : new UI_FightSkillRightBubble;
        this._bubble.cacheAsBitmap = true;
        this._skillNameTxt = this._bubble["skillNameTxt"];
        addChild(this._bubble);
        this.alpha = 0;
        this.x = this._side == FightSide.LEFT ? 292 : 909;
        this.y = 125;
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemoved);
    }

    public function setSkillName(param1:String):void {
        this._bubbleContent = param1;
        this._skillNameTxt.text = this._bubbleContent;
        this.emerge();
    }

    private var _shrinkTimeout:uint;

    private function emerge():void {
        this.visible = true;
        TweenLite.killTweensOf(this);
        TweenLite.to(this, 0.5, {
            "alpha": 1,
            "ease": Strong.easeIn,
            "onComplete": this.onEmerge
        });
    }

    private function onEmerge():void {
        this._skillNameTxt.text = this._bubbleContent;
        clearTimeout(_shrinkTimeout);
        _shrinkTimeout = setTimeout(this.shrink, 2000);
    }

    private function shrink():void {
        TweenLite.killTweensOf(this);
        TweenLite.to(this, 0.5, {
            "alpha": 0,
            "ease": Strong.easeIn,
            "onComplete": this.onComplete
        });
    }

    private function onComplete():void {
        if (this) {
            this.visible = false;
        }
    }

    private function onRemoved(param1:Event):void {
        clearTimeout(_shrinkTimeout);
        TweenLite.killTweensOf(this);
    }
}
}
