package animation.layer {
import animation.loading.ArenaLoadingBar;
import animation.loading.FighterRevenuePanel;

import data.pet.FrameData;

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.utils.setTimeout;

import ui.end.UI_ScreenCover;

import utils.Utils;
import utils.an.DisplayObjectUtil;

public class FaceLayer extends Sprite {

    public function playStart(frame:FrameData, cb:Function):void {
        var arenaLoadingBar:ArenaLoadingBar = new ArenaLoadingBar();
        arenaLoadingBar.initData(frame.data.left, frame.data.right, frame.start.tips);
        addChild(arenaLoadingBar);
        Utils.once(arenaLoadingBar, Event.CLOSE, function ():void {
            arenaLoadingBar.dispose();
            cb();
        })
        setTimeout(function ():void {
            arenaLoadingBar.updateProgress(100);
        }, 2500);
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
