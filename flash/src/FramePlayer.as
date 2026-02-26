package {
import animation.event.Events;
import animation.layer.BackLayer;
import animation.layer.FaceLayer;
import animation.layer.FrontLayer;
import animation.layer.PetLayer;
import animation.layer.SoundLayer;
import animation.layer.UILayer;

import data.pet.FrameData;

import flash.display.Sprite;
import flash.events.Event;
import flash.system.System;
import flash.text.TextField;
import flash.utils.setInterval;
import flash.utils.setTimeout;

import utils.an.DisplayObjectUtil;

public class FramePlayer extends Sprite {

    private var bgLayer:BackLayer;
    private var petLayer:PetLayer;
    private var uiLayer:UILayer;
    private var fgLayer:FrontLayer;
    private var faceLayer:FaceLayer;
    private var soundLayer:SoundLayer;

    private var _version:int;

    public function FramePlayer() {
        this.bgLayer = new BackLayer();
        this.petLayer = new PetLayer();
        this.uiLayer = new UILayer();
        this.fgLayer = new FrontLayer();
        this.faceLayer = new FaceLayer();
        this.soundLayer = new SoundLayer();

        addChild(bgLayer);
        addChild(petLayer);
        addChild(uiLayer);
        addChild(fgLayer);
        addChild(faceLayer);
        petLayer.bgLayer = bgLayer;
        petLayer.fgLayer = fgLayer;
        petLayer.soundLayer = soundLayer;
    }

    public function playFrame(frame:FrameData, next:Function):void {
        _version++;
        var version:int = _version;
        DisplayObjectUtil.disableSprite(uiLayer);
        var next0:Function = next;
        next = function ():void {
            if (!checkVersion(version)) {
                return;
            }
            DisplayObjectUtil.enableSprite(uiLayer);
            next0();
        }

        function loadFrame(cb:Function):void {
            var flag:Boolean = false;
            petLayer.initData(frame, function (event:Event):void {
                if (!checkVersion(version)) {
                    return;
                }
                if (!flag) {
                    flag = true;
                    bgLayer.initData(frame.data.mapSwf);
                    soundLayer.playMapSound(frame.data.mapSound);
                    uiLayer.initData(frame.data);
                }
                if (event.type === Events.FRAME_PLAY_END) {
                    cb();
                }
            });
        }

        if (frame.logs) {
            uiLayer.appendLogs(frame.logs);
        }
        if (frame.sleep > 0 || !frame.data) {
            setTimeout(function ():void {
                if (!checkVersion(version)) {
                    return;
                }
                next();
            }, frame.sleep);
        } else if (frame.start) {
            faceLayer.playStart(frame, function ():void {
                if (!checkVersion(version)) {
                    return;
                }
                loadFrame(next);
            });
        } else if (frame.end) {
            fgLayer.playKO(function ():void {
                if (!checkVersion(version)) {
                    return;
                }
                loadFrame(function ():void {
                    if (!checkVersion(version)) {
                        return;
                    }
                    faceLayer.playEnd(frame.end.winner, next);
                });
            });
        } else {
            loadFrame(next);
            uiLayer.showSkillBubble(frame.move);
        }
    }

    private function checkVersion(version:int):Boolean {
        return this._version === version;
    }

    private static function showDebug(framePlayer:FramePlayer):void {
        var textField:TextField = new TextField();
        textField.y = 300;
        textField.textColor = 0xff0000;
        textField.width = 500;
        framePlayer.addChild(textField);
        setInterval(function ():void {
            var _this:FramePlayer = framePlayer;
            textField.text = ""
                    + "bgLayer children:" + _this.bgLayer.numChildren + "\n"
                    + "petLayer children:" + _this.petLayer.numChildren + "\n"
                    + "uiLayer children:" + _this.uiLayer.numChildren + "\n"
                    + "fgLayer children:" + _this.fgLayer.numChildren + "\n"
                    + "faceLayer children:" + _this.faceLayer.numChildren + "\n"
                    + "system memory:" + int(System.totalMemory / 1024 / 1024) + "MB" + "\n"
            ;
        }, 1000);
    }

    public function updateUiStyle(uiStyle:int):void {
        uiLayer.updateUiStyle(uiStyle);
    }

    public function updateGlobalSound(sound:Number):void {
        soundLayer.updateGlobalSound(sound);
    }

    public function updateMapSound(sound:Number):void {
        soundLayer.updateMapSound(sound);
    }
}
}
