package ui.hub {
import flash.display.MovieClip;
import flash.display.SimpleButton;

[Embed(source="/_assets/assets.swf", symbol="UI_FightHub")]
public dynamic class UI_FightHub extends MovieClip
{

    public var autoBtn:SimpleButton;

    public var catchMc:MovieClip;

    public var escapeMc:MovieClip;

    public var fightBtn:SimpleButton;

    public var itemMc:MovieClip;

    public var petMc:MovieClip;

    public var settingBtn:SimpleButton;

    public function UI_FightHub()
    {
        super();
    }
}
}