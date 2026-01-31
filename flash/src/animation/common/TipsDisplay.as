package animation.common {
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

import ui.common.UI_multipleTooltip;

import utils.an.DisplayObjectUtil;

public class TipsDisplay extends Sprite {
    private var _tipSkin:MovieClip;
    private var _tipTxt:TextField;
    private var _back:MovieClip;

    private var _source:Sprite;
    private var _tips:String;
    private var _left:Boolean;

    public function TipsDisplay(param1:Sprite) {
        addChild(param1);
        _tipSkin = new UI_multipleTooltip;
        _tipTxt = _tipSkin["tipTxt"];
        _tipTxt.width = 160;
        _tipTxt.wordWrap = true;
        _tipTxt.autoSize = TextFieldAutoSize.LEFT;
        _back = _tipSkin["backMC"];
        DisplayObjectUtil.disableSprite(_tipSkin);

        _source = param1;
        _source.addEventListener(MouseEvent.ROLL_OVER, this.onTargetOver);
        _source.addEventListener(MouseEvent.ROLL_OUT, this.onTargetOut);
    }

    public function initData(tips:String):void {
        this._tips = tips;
    }

    private function onTargetOver(param1:MouseEvent):void {
        if (!_tips) {
            return;
        }
        this._tipTxt.htmlText = _tips || '';
        _back.width = _tipTxt.textWidth + 20;
        _back.height = _tipTxt.textHeight + 20;
        this.deployTooltip();
        stage.addChild(_tipSkin);
    }

    private function onTargetOut(param1:MouseEvent):void {
        DisplayObjectUtil.removeFromParent(_tipSkin);
    }

    private function deployTooltip():void {
        var pos:Point = _source.localToGlobal(new Point(0, 0));
        if (_left) {
            this._tipSkin.x = pos.x - this._tipSkin.width;
        } else {
            this._tipSkin.x = pos.x + this._source.width;
        }
        this._tipSkin.y = pos.y + this._source.height;
    }

    public function setLeft(left:Boolean):void {
        this._left = left;
    }

}
}
