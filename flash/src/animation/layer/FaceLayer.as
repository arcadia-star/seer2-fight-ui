package animation.layer {
import animation.loading.ArenaLoadingBar;
import animation.loading.FighterRevenuePanel;

import data.pet.FrameData;

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.utils.getTimer;
import flash.utils.setTimeout;

import ui.end.UI_ScreenCover;

import utils.Utils;
import utils.an.DisplayObjectUtil;

public class FaceLayer extends Sprite {

    private var _loadingBar:ArenaLoadingBar;

    public function playStart(frame:FrameData, cb:Function):void {
        _loadingBar = new ArenaLoadingBar();
        _loadingBar.initData(frame.data.left, frame.data.right, frame.start.tips);
        addChild(_loadingBar);
        Utils.once(_loadingBar, Event.CLOSE, function ():void {
            _loadingBar.dispose();
            _loadingBar = null;
            cb();
        });
        setTimeout(function ():void {
            if(_loadingBar) {
                _loadingBar.updateProgress(100);
            }
        }, 33000);//加载界面最多等待30秒吧，20太少40超时了
    }

    public function setLoadingBarProgress(val:uint) : void {
        if(val >= 0 || val <= 100) {
            if (_loadingBar) {
                _loadingBar.updateProgress(val);
            }
        }
    }

    public function playEnd(side:int, cb:Function):void {
        var sprite:Sprite = new Sprite();

        var coverUI:UI_ScreenCover = new UI_ScreenCover();
        coverUI.cacheAsBitmap = true;
        sprite.addChild(coverUI);

        var shadow:Shape = new Shape();
        shadow.graphics.beginFill(0, 0.8);
        shadow.graphics.drawRect(0, 0, 1200, 660);
        shadow.graphics.endFill();
        sprite.addChild(shadow);

        var fighterRevenuePanel:FighterRevenuePanel = new FighterRevenuePanel;
        fighterRevenuePanel.initData(side);
        sprite.addChild(fighterRevenuePanel);

        addChild(sprite);
        Utils.once(fighterRevenuePanel, Event.CLOSE, function ():void {
            DisplayObjectUtil.removeFromParent(sprite);
            cb();
        });
    }
}
}
