package utils {
import flash.display.DisplayObject;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.display.MovieClip;
import flash.display.Stage;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.external.ExternalInterface;
import flash.media.Sound;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.utils.setTimeout;

public class Utils {

    public static function once(dispatcher:IEventDispatcher, name:String, cb:Function):void {
        dispatcher.addEventListener(name, handleOnce);

        function handleOnce(event:Event):void {
            dispatcher.removeEventListener(name, handleOnce);
            cb();
        }
    }

    public static function load(url:String, cb:Function, onError:Function = null):Loader {
        var loader:Loader = new Loader();
        var contentLoaderInfo:LoaderInfo = loader.contentLoaderInfo;
        function handleComplete(event:Event):void {
            contentLoaderInfo.removeEventListener(Event.COMPLETE, handleComplete);
            contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handleError);
            contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleError);
            cb(contentLoaderInfo)
        }
        function handleError(event:Event):void {
            contentLoaderInfo.removeEventListener(Event.COMPLETE, handleComplete);
            contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handleError);
            contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleError);
            onError && onError(event)
        }
        contentLoaderInfo.addEventListener(Event.COMPLETE, handleComplete);
        contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleError);
        contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleError);
        loader.load(new URLRequest(url));
        return loader;
    }

    public static function loadText(url:String, cb:Function, onError:Function = null):void {
        var loader:URLLoader = new URLLoader();
        loader.dataFormat = URLLoaderDataFormat.TEXT;
        function handleComplete(event:Event):void {
            loader.removeEventListener(Event.COMPLETE, handleComplete);
            loader.removeEventListener(IOErrorEvent.IO_ERROR, handleError);
            loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleError);
            cb(loader.data)
        }
        function handleError(event:Event):void {
            loader.removeEventListener(Event.COMPLETE, handleComplete);
            loader.removeEventListener(IOErrorEvent.IO_ERROR, handleError);
            loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleError);
            onError && onError(event)
        }
        loader.addEventListener(Event.COMPLETE, handleComplete);
        loader.addEventListener(IOErrorEvent.IO_ERROR, handleError);
        loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleError);
        loader.load(new URLRequest(url));
    }

    public static function loadSound(url:String, cb:Function, onError:Function = null):void {
        var sound:Sound = new Sound();
        function handleComplete(event:Event):void {
            sound.removeEventListener(Event.COMPLETE, handleComplete);
            sound.removeEventListener(IOErrorEvent.IO_ERROR, handleError);
            sound.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleError);
            cb(sound)
        }
        function handleError(event:Event):void {
            sound.removeEventListener(Event.COMPLETE, handleComplete);
            sound.removeEventListener(IOErrorEvent.IO_ERROR, handleError);
            sound.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleError);
            onError && onError(event)
        }
        sound.addEventListener(Event.COMPLETE, handleComplete);
        sound.addEventListener(IOErrorEvent.IO_ERROR, handleError);
        sound.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleError);
        sound.load(new URLRequest(url));
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
                async(cb)
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

    public static function onComplete(mc:MovieClip, cb:Function):void {
        var done:Boolean = false;
        mc.addEventListener(Event.ENTER_FRAME, handleEnterFrame);
        mc.addEventListener(Event.REMOVED_FROM_STAGE, handleRemoved);

        function cleanup():void {
            mc.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
            mc.removeEventListener(Event.REMOVED_FROM_STAGE, handleRemoved);
        }

        function complete():void {
            if (done) {
                return;
            }
            done = true;
            cleanup();
            cb();
        }

        function handleEnterFrame(event:Event):void {
            if (mc.currentFrame == mc.totalFrames) {
                complete();
            }
        }

        function handleRemoved(event:Event):void {
            complete();
        }
    }

    public static function jsonParse(text:String):* {
        return JSON.parse(text);
    }

    public static function jsonStringify(object:*):* {
        return JSON.stringify(object);
    }

    public static function center(child:DisplayObject, stage:Stage):void {
        child.x = stage.stageWidth - child.width >> 1;
        child.y = stage.stageHeight - child.height >> 1;
    }

    public static function async(fn:Function):void {
        setTimeout(fn, 0);
    }
}
}
