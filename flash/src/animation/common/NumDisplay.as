package animation.common {
import flash.display.MovieClip;
import flash.filters.BitmapFilterQuality;
import flash.filters.GlowFilter;
import flash.text.TextField;
import flash.text.TextFormat;

public class NumDisplay extends MovieClip {
    private var _textField:TextField;
    private var _num:int;

    public function NumDisplay() {
        var textField:TextField = new TextField();
        var textFormat:TextFormat = new TextFormat("_sans", 12);
        textFormat.align = "right";
        textField.defaultTextFormat = textFormat;
        textField.textColor = 16777215;
        textField.text = _num + "";
        textField.width = 32;
        textField.height = 17;
        var glowFilter:GlowFilter = new GlowFilter();
        glowFilter.color = 3342336; // 描边颜色
        glowFilter.alpha = 1; // 完全不透明
        glowFilter.blurX = 2; // 水平模糊量，控制描边宽度
        glowFilter.blurY = 2; // 垂直模糊量，控制描边宽度
        glowFilter.strength = 100; // 强度，设置得足够大以使边缘清晰
        glowFilter.quality = BitmapFilterQuality.LOW; // 使用高质量，避免模糊
        glowFilter.inner = false; // 不是内侧发光
        glowFilter.knockout = false; // 不挖空
        textField.filters = [glowFilter];
        addChild(textField);
        this._textField = textField;
    }

    public function initData(num:int):void {
        if (this._num === num) {
            return;
        }
        this._num = num;
        if (_num > 9999) {
            this._textField.text = "1w+";
        } else {
            this._textField.text = _num + "";
        }
    }
}
}
