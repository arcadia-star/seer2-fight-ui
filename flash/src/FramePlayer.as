package {
import animation.layer.BackLayer;
import animation.layer.FaceLayer;
import animation.layer.FrontLayer;
import animation.layer.PetLayer;
import animation.layer.SoundLayer;
import animation.layer.UILayer;

import data.pet.FrameData;

import flash.display.Sprite;
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
            petLayer.initData(frame, function ():void {
                if (!checkVersion(version)) {
                    return;
                }
                bgLayer.initData(frame.data.mapSwf);
                soundLayer.playMapSound(frame.data.mapSound);
                uiLayer.initData(frame.data);
                cb();
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
}
}
