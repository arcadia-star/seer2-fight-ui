package {
import animation.common.IconDisplay;

import flash.display.LoaderInfo;
import flash.display.Sprite;


[SWF(width="128", height="128", frameRate="24")]
public class ItemPlayer extends Sprite {

    public function ItemPlayer() {
        var loaderInfo:LoaderInfo = LoaderInfo(this.root.loaderInfo);
        var params:Object = loaderInfo.parameters;
        var url:String = params["url"] || "http://seer2.61.com/res/pet/icon/10.swf";
        var icon:IconDisplay = new IconDisplay();
        icon.setSize(128);
        icon.initData(url);
        addChild(icon);
    }
}
}
