package {
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.display.MovieClip;
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

    public static function callJs(func:String, type0:String, data:Object = null, version:Object = null):void {
        if (ExternalInterface.available) {
            ExternalInterface.call(func, {func: func, "type": type0, data: data, version: version});
        }
    }

    public static function addCallbackJs(functionName:String, closure:Function):void {
        if (ExternalInterface.available) {
            ExternalInterface.addCallback(functionName, closure);
        }
    }

    public static function promiseAll(array:Array, cb:Function):void {

        function mayCb():void {
            if (cnt == 0) {
                cnt -= 1;
                cb();
            }
        }

        var cnt:uint = array.length;

        mayCb();
        for (var i:int = 0; i < array.length; i++) {
            array[i](function ():void {
                cnt -= 1;
                mayCb();
            })
        }
    }

    public static function hasLabel(mc:MovieClip, label:String):Boolean {
        return mc.currentLabels.some(function (e:Object, index:int, array:Array):Boolean {
            return e.name == label;
        });
    }
}
}
