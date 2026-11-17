package animation.status {
import animation.common.PetIconDisplay;
import data.pet.PetData;
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.ColorTransform;

internal class NormalCapsuleBar {
    private static const CAPSULE_NUM:int=6;
    private var _view:MovieClip;
    private var _backVec:Vector.<MovieClip>=new Vector.<MovieClip>();
    private var _tipVec:Vector.<MovieClip>=new Vector.<MovieClip>();
    private var _petIconVec:Vector.<PetIconDisplay>=new Vector.<PetIconDisplay>();
    public function NormalCapsuleBar(view:MovieClip) {
        _view=view;
        for(var i:int=0;i<CAPSULE_NUM;i++) {
            var back:MovieClip=view["pet"+i];
            var tip:MovieClip=view["tip"+i];
            tip.visible=false;
            _backVec.push(back);_tipVec.push(tip);
            back["capsule"].gotoAndStop(1);back["back"].gotoAndStop(1);back["cover"].gotoAndStop(1);
            (function(b:MovieClip,t:MovieClip):void {
                b.addEventListener(MouseEvent.MOUSE_OVER,function(e:MouseEvent):void {t.visible=true;});
                b.addEventListener(MouseEvent.MOUSE_OUT,function(e:MouseEvent):void {t.visible=false;});
            })(back,tip);
            var icon:PetIconDisplay=new PetIconDisplay();
            icon.setSize(30);icon.mouseEnabled=icon.mouseChildren=false;icon.visible=false;
            back["portrait"].addChild(icon);_petIconVec.push(icon);
        }
    }
    public function initData(param1:Vector.<PetData>):void {
        this._view.visible = true;
        for (var idx:int = 0; idx < CAPSULE_NUM; idx++) {
            var icon:PetIconDisplay = this._petIconVec[idx];
            this._backVec[idx].visible = idx < param1.length;
            if (idx < param1.length) {
                var pet:PetData = param1[idx];
                icon.initData(pet.petIcon);
                if (!pet.ext || pet.ext.showIcon) {
                    icon.visible = true;
                    var mc:MovieClip = this._backVec[idx]["capsule"];
                    if(mc.currentFrame == 1) {
                        (function(m:MovieClip):void {
                            m.addFrameScript(m.totalFrames - 1, function():void {
                                m.stop();
                            });
                        })(mc);
                        mc.play();
                    }
                    mc = this._backVec[idx]["back"];
                    if(mc.currentFrame == 1) {
                        (function(m:MovieClip):void {
                            m.addFrameScript(m.totalFrames - 1, function():void {
                                m.stop();
                            });
                        })(mc);
                        mc.play();
                    }
                    mc = this._backVec[idx]["cover"];
                    if(mc.currentFrame == 1) {
                        (function(m:MovieClip):void {
                            m.addFrameScript(m.totalFrames - 1, function():void {
                                m.stop();
                            });
                        })(mc);
                        mc.play();
                    }
                    this._tipVec[idx]["nameTxt"].text = pet.name;
                    this._tipVec[idx]["hpTxt"].text = pet.hp + "/" + pet.maxHp;
                }
                else {
                    icon.visible = false;
                    this._tipVec[idx]["nameTxt"].text = "???";
                    this._tipVec[idx]["hpTxt"].text = "???/???";
                }
                if (pet.alive > 0) {
                    setColor(icon,true);
                } else {
                    setColor(icon,false);
                }
            }
            else {
                icon.visible = false;
            }
        }
    }

    private function setColor(mc:DisplayObject, hasColor:Boolean):void {
        var ct:ColorTransform = new ColorTransform();
        if (!hasColor) {
            // 黑白：降低饱和度效果
            ct.redMultiplier = 0.33;
            ct.greenMultiplier = 0.33;
            ct.blueMultiplier = 0.33;
        } else {
            // 彩色：恢复正常
            ct.redMultiplier = 1;
            ct.greenMultiplier = 1;
            ct.blueMultiplier = 1;
        }
        mc.transform.colorTransform = ct;
    }
}
}
