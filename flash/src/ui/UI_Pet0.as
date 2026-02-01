package ui {
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.Event;

public class UI_Pet0 {
    [Embed(source="/assets/pet0.swf", mimeType="application/octet-stream")]
    private static var Pet0SwfBytes:Class;

    [Embed(source="/assets/pet0.swf", symbol="pet")]
    public static var Pet0:Class;

    {
        loadClass();
    }

    public static function loadClass():void {
        var loader:Loader = new Loader();
        var loaderInfo:LoaderInfo = loader.contentLoaderInfo;
        loaderInfo.addEventListener(Event.COMPLETE, function (event:Event):void {
            Pet0 = loaderInfo.applicationDomain.getDefinition("pet") as Class;
        });
        loader.loadBytes(new Pet0SwfBytes);
    }
}
}
