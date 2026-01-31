package animation.layer {
import animation.alert.ConfirmAlert;
import animation.alert.SelectAlert;
import animation.event.Events;

import data.Constant;

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;

import utils.Utils;
import utils.an.DisplayObjectUtil;

public class AlertLayer extends Sprite {
    private var _maskShape:Shape;

    public function AlertLayer() {
        _maskShape = new Shape();
        _maskShape.graphics.clear();
        _maskShape.graphics.beginFill(0x000000, 0.3);
        _maskShape.graphics.drawRect(0, 0, Constant.MAIN_WIDTH, Constant.MAIN_HEIGHT);
        _maskShape.graphics.endFill();
        addChild(_maskShape);
        updateMask();
    }

    public function confirm(message:String, confirm:Function = null, cancel:Function = null):void {
        var alert:ConfirmAlert = new ConfirmAlert();
        alert.initData(message, confirm, cancel);
        show(alert);
    }

    public function select(message:String, data:Array, confirm:Function = null, cancel:Function = null):void {
        var alert:SelectAlert = new SelectAlert();
        alert.initData(message, data, confirm, cancel);
        show(alert);
    }

    private function show(alert:Sprite):void {
        alert.addEventListener(Events.ALERT_END, function (event:Event):void {
            DisplayObjectUtil.removeFromParent(alert);
            updateMask();
        });
        addChild(alert);
        Utils.center(alert, stage);
        updateMask();
    }

    private function updateMask():void {
        this.mouseChildren = numChildren > 1;
        this._maskShape.visible = this.mouseChildren;
    }
}
}
