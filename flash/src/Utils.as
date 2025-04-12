package {
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.external.ExternalInterface;
import flash.net.URLRequest;

public class Utils {

    public static function once(dispatcher:IEventDispatcher, name:String, cb:Function):void {
        dispatcher.addEventListener(name, handleOnce);

        function handleOnce(event:Event):void {
            dispatcher.removeEventListener(name, handleOnce);
            cb();
        }
    }

    public static function loadSwf(url:String, cb:Function, onError:Function = null):void {
        var loader:Loader = new Loader();
        var contentLoaderInfo:LoaderInfo = loader.contentLoaderInfo;
        contentLoaderInfo.addEventListener(Event.COMPLETE, function (event:Event):void {
            cb(contentLoaderInfo.applicationDomain)
        });
        contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function (event:Event):void {
            onError && onError(event)
        });
        loader.load(new URLRequest(url));
    }

    public static function callJs(func:String, event:String, data:Object = null):void {
        if (ExternalInterface.available) {
            ExternalInterface.call(func, {func: func, event: event, data: data});
        }
    }

    public static function addCallbackJs(functionName:String, closure:Function):void {
        if (ExternalInterface.available) {
            ExternalInterface.addCallback(functionName, closure);
        }
    }
}
}
