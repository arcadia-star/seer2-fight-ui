package {
import animation.layer.SoundLayer;

import data.Config;
import data.pet.FrameData;

import flash.display.Sprite;

import ui.Resource;

import utils.Utils;

[SWF(width="1200", height="660", frameRate="24")]
public class FightPlayer extends Sprite {
    private var config:Config;
    private var framePlayer:FramePlayer;

    public function FightPlayer() {
        Resource.init();
        this.config = Config.from(this);
        this.framePlayer = new FramePlayer();
        addChild(framePlayer);

        Utils.addCallbackJs("playFrame", playFrame);
        Utils.addCallbackJs("updateGlobalSound", updateGlobalSound);
        Utils.addCallbackJs("updateMapSound", updateMapSound);
        Utils.async(function ():void {
            callJs('init')
        })
    }

    public function playFrame(frame:Object, version:Object):void {
        var frameData:FrameData = FrameData.from(frame);
        callJs("playStart", null, version);
        framePlayer.playFrame(frameData, function ():void {
            callJs("playEnd", null, version);
        })
    }

    public function updateGlobalSound(volume:Number):void {
        SoundLayer.updateGlobalSound(volume / 100);
    }

    public function updateMapSound(volume:Number):void {
        SoundLayer.updateMapSound(volume / 100);
    }

    public function callJs(type0:String, data:Object = null, version:Object = null):void {
        Utils.callJs(config.jsCallback, type0, data, version);
    }
}
}
