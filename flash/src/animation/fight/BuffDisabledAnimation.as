package animation.fight {
import animation.event.Events;
import com.greensock.TweenLite;
import com.greensock.easing.Expo;
import enums.FightSide;
import flash.display.Sprite;
import ui.splash.BuffTipResources;
import utils.an.DisplayObjectUtil;

// 对应旧 UI BuffDisabledAnimation：原资源、大字缩放上浮及淡出。
public class BuffDisabledAnimation extends Sprite {
    public static const BUFF_IDS:Vector.<int> = Vector.<int>([1, 2, 3, 5, 6, 7, 8, 9, 12]);

    public function BuffDisabledAnimation(buffId:int, side:int) {
        var tipClass:Class = BuffTipResources.getTip(buffId);
        addChild(new tipClass());
        x = side === FightSide.LEFT ? 200 : 760;
        y = 350;
        scaleX = scaleY = 3;
        DisplayObjectUtil.disableSprite(this);
    }

    public function play():void {
        TweenLite.to(this, 3, {
            "y": 180,
            "scaleX": 1.5,
            "scaleY": 1.5,
            "ease": Expo.easeOut,
            "onComplete": fadeOut
        });
    }

    private function fadeOut():void {
        TweenLite.to(this, 1, {
            "alpha": 0,
            "ease": Expo.easeOut,
            "onComplete": function ():void {
                dispatchEvent(Events.animationEnd());
            }
        });
    }
}
}
