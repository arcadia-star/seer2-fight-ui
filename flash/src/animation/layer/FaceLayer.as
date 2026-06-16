package animation.layer {
import animation.loading.ArenaLoadingBar;
import animation.loading.FighterRevenuePanel;

import data.pet.FrameData;

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.utils.setTimeout;

import ui.end.UI_ScreenCover;

import utils.CacheUtils;

import utils.Utils;
import utils.an.DisplayObjectUtil;

public class FaceLayer extends Sprite {

    private var _loadingBar:ArenaLoadingBar;

    private var _version:int;

    public function playStart(frame:FrameData, cb:Function):void {
        _version++;
        var version:int = _version;

        //重复播放时，丢弃上次的动画，然后重新加载新的动画
        removeLoadingBar();
        _loadingBar = new ArenaLoadingBar();
        _loadingBar.initData(frame.data.left, frame.data.right, frame.start.tips);
        addChild(_loadingBar);

        //加载完成后，回调上游
        Utils.once(_loadingBar, Event.CLOSE, function ():void {
            if (!checkVersion(version)) {
                return;
            }
            removeLoadingBar();
            cb();
        });

        //预加载url资源
        var loadUrls:Vector.<String> = frame.start.urls;
        var loadTasks:Array = [];
        for each (var url:String in loadUrls) {
            loadTasks.push(createLoadTask(url));
        }
        var loadedCount:int = 0;

        function createLoadTask(url:String):Function {
            return function (cb:Function):void {
                function ready():void {
                    loadedCount++;
                    //最多99，100由最终函数完成
                    updateProgress(Math.min(100 * loadedCount / loadUrls.length, 99));
                    cb();
                }

                if (url.indexOf("res/pet/fight/") != -1) {
                    CacheUtils.loadPet(url, function (pet:*):void {
                        ready()
                    });
                } else {
                    ready();
                }
            };
        }

        Utils.promiseAll(loadTasks, function ():void {
            updateProgress(100);
        }, 20000);//加载界面最多等待20秒，太多了体验不是很好

        function updateProgress(progress:int):void {
            readyProgress = Math.max(progress, readyProgress);
            if (ready && _loadingBar) {
                _loadingBar.updateProgress(progress);
            }
        }

        //动画连续性，必须等待2.5s
        var ready:Boolean = false;
        var readyProgress:int = 0;
        setTimeout(function ():void {
            ready = true;
            updateProgress(readyProgress);
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

    private function checkVersion(version:int):Boolean {
        return this._version === version;
    }

    private function removeLoadingBar():void {
        if (_loadingBar) {
            _loadingBar.dispose();
            _loadingBar = null;
        }
    }
}
}
