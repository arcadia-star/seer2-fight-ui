package ui.common {
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.text.TextField;

[Embed(source="/_assets/assets.swf", symbol="UI_Confirm")]
public dynamic class UI_Confirm extends MovieClip {
    public var cancelBtn:SimpleButton;

    public var contentTxt:TextField;

    public var confirmBtn:SimpleButton;
}
}
