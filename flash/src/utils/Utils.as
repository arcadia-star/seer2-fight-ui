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

    public static function repeat(dispatcher:IEventDispatcher, name:String, times:int, cb:Function):void {
        //重复触发器，设置监听dispatcher，若其派发了name事件，则执行cb，累计触发times次后销毁该监听
        dispatcher.addEventListener(name, handle);
        var count:int = 0;
        function handle(event:Event):void {
            count++;
            cb();
            if(count >= times) {
                dispatcher.removeEventListener(name, handle);
            }
        }
    }

    public static function load(url:String, cb:Function, onError:Function = null):Loader {
        var loader:Loader = new Loader();
        var contentLoaderInfo:LoaderInfo = loader.contentLoaderInfo;
        contentLoaderInfo.addEventListener(Event.COMPLETE, function (event:Event):void {
            cb(contentLoaderInfo)
        });
        contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function (event:Event):void {
            onError && onError(event)
        });
        contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function (event:Event):void {
            onError && onError(event)
        });
        loader.load(new URLRequest(url));
        return loader;
    }

    public static function loadText(url:String, cb:Function, onError:Function = null):void {
        var loader:URLLoader = new URLLoader();
        loader.dataFormat = URLLoaderDataFormat.TEXT;
        loader.addEventListener(Event.COMPLETE, function (event:Event):void {
            cb(loader.data)
        });
        loader.addEventListener(IOErrorEvent.IO_ERROR, function (event:Event):void {
            onError && onError(event)
        });
        loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function (event:Event):void {
            onError && onError(event)
        });
        loader.load(new URLRequest(url));
    }

    public static function loadSound(url:String, cb:Function, onError:Function = null):void {
        var sound:Sound = new Sound();
        sound.addEventListener(Event.COMPLETE, function (event:Event):void {
            cb(sound)
        });
        sound.addEventListener(IOErrorEvent.IO_ERROR, function (event:Event):void {
            onError && onError(event)
        });
        sound.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function (event:Event):void {
            onError && onError(event)
        });
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
        mc.addEventListener(Event.ENTER_FRAME, handleEnterFrame);

        function handleEnterFrame(event:Event):void {
            if (mc.currentFrame == mc.totalFrames) {
                mc.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
                cb();
            }
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
