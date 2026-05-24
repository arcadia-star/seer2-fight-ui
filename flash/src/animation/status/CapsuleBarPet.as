package animation.status {
import animation.common.PetIconDisplay;

import data.pet.PetData;

import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.ColorTransform;

import ui.status.UI_FightCapsulePet;
import ui.status.UI_FightCapsulePetTip;

internal class CapsuleBarPet extends Sprite {
    private static const CAPSULE_NUM:int = 6;
    private static const CAPSULE_WIDTH:int = 36;
    private var _backVec:Vector.<MovieClip>;
    private var _tipVec:Vector.<MovieClip>;
    private var _petIconVec:Vector.<PetIconDisplay>;
    private var _lastIconUrls:Array;
    private var _lastShown:Array;
    private var _lastAlive:Array;
    private var _lastNames:Array;
    private var _lastHpText:Array;
    private static var _petHasShown:Array = [false, false, false, false, false, false];
    private var _side:int = 0;
    public static const CAPSULE_SIDE_LEFT:int = 0;
    public static const CAPSULE_SIDE_RIGHT:int = 1;

    public function CapsuleBarPet(side:int = CAPSULE_SIDE_LEFT) {
        super();
        this._side = side;
        var i:int = 0;
        var _loc5_:MovieClip = null;
        this._tipVec = new Vector.<MovieClip>();
        while (i < CAPSULE_NUM) {
            _loc5_ = new UI_FightCapsulePetTip;
            _loc5_.x = CAPSULE_WIDTH;
            _loc5_.y = i * CAPSULE_WIDTH;
            this._tipVec.push(_loc5_);
            _loc5_.visible = false;
            addChild(_loc5_);
            if(this._side) {
                _loc5_.scaleX *= -1;
                _loc5_.x += _loc5_.width;
            }
            i++;
        }
        i = 0;
        this._backVec = new Vector.<MovieClip>();
        while (i < CAPSULE_NUM) {
            (_loc5_ = new UI_FightCapsulePet).y = i * CAPSULE_WIDTH;
            _loc5_["capsule"].gotoAndStop(1);
            _loc5_["back"].gotoAndStop(1);
            _loc5_["cover"].gotoAndStop(1);
            this._backVec.push(_loc5_);
            (function(idx:int):void {
                _loc5_.addEventListener(MouseEvent.MOUSE_OVER,function(e:MouseEvent):void {
                    _tipVec[idx].visible = true;
                });
                _loc5_.addEventListener(MouseEvent.MOUSE_OUT,function(e:MouseEvent):void {
                    _tipVec[idx].visible = false;
                });
            })(i);
            addChild(_loc5_);
            i++;
        }

        this._petIconVec = new Vector.<PetIconDisplay>();
        this._lastIconUrls = [];
        this._lastShown = [];
        this._lastAlive = [];
        this._lastNames = [];
        this._lastHpText = [];
        var _loc4_:PetIconDisplay = null;
        i = 0;
        while (i < CAPSULE_NUM) {
            (_loc4_ = new PetIconDisplay).y = i * CAPSULE_WIDTH + 1;
            _loc4_.x = 1;
            this._petIconVec.push(_loc4_);
            _loc4_.setScale(30/54, 30/54);
            _loc4_.mask = this._backVec[i]["cover"];
            _loc4_.mouseEnabled = _loc4_.mouseChildren = false;
            _loc4_.visible = false;
            addChild(_loc4_);
            i++;
        }
        this.visible = false;
    }

    public function initData(param1:Vector.<PetData>):void {
        this.visible = true;
        for (var idx:int = 0; idx < CAPSULE_NUM; idx++) {
            var icon:PetIconDisplay = this._petIconVec[idx];
            if (idx < param1.length) {
                var pet:PetData = param1[idx];
                if (!this._backVec[idx].visible) {
                    this._backVec[idx].visible = true;
                }
                if (this._lastIconUrls[idx] !== pet.petIcon) {
                    icon.initData(pet.petIcon);
                    this._lastIconUrls[idx] = pet.petIcon;
                }
                var shown:Boolean = this._side == CAPSULE_SIDE_LEFT || _petHasShown[idx];
                if (shown) {
                    if (this._lastShown[idx] !== true) {
                        icon.visible = true;
                        this._lastShown[idx] = true;
                    }
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
                    if (this._lastNames[idx] !== pet.name) {
                        this._tipVec[idx]["nameTxt"].text = pet.name;
                        this._lastNames[idx] = pet.name;
                    }
                    var hpText:String = pet.hp + "/" + pet.maxHp;
                    if (this._lastHpText[idx] !== hpText) {
                        this._tipVec[idx]["hpTxt"].text = hpText;
                        this._lastHpText[idx] = hpText;
                    }
                }
                else {
                    if (this._lastShown[idx] !== false) {
                        icon.visible = false;
                        this._tipVec[idx]["nameTxt"].text = "???";
                        this._tipVec[idx]["hpTxt"].text = "???/???";
                        this._lastShown[idx] = false;
                        this._lastNames[idx] = null;
                        this._lastHpText[idx] = null;
                    }
                }
                var alive:Boolean = pet.alive > 0;
                if (this._lastAlive[idx] !== alive) {
                    setColor(icon, alive);
                    this._lastAlive[idx] = alive;
                }
            }
            else {
                if (this._lastShown[idx] !== null) {
                    this._backVec[idx].visible = false;
                    icon.visible = false;
                    icon.initData(null);
                    this._lastIconUrls[idx] = null;
                    this._lastShown[idx] = null;
                    this._lastAlive[idx] = null;
                    this._lastNames[idx] = null;
                    this._lastHpText[idx] = null;
                }
            }
        }
    }

    static public function petShown(idx:int):void {
        _petHasShown[idx] = true;
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
