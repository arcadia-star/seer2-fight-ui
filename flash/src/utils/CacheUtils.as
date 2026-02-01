package utils {
import ui.IconFallback;
import ui.SkillEffect0;
import ui.UI_Pet0;
import ui.sound.MapSound0;
import ui.sound.PetSound0;
import ui.sound.SkillSound0;

public class CacheUtils {

    public static function loadItem(url:String, cb:Function):void {
        CacheUtils0.loadClass(url, cb, "item", IconFallback);
    }

    public static function loadEffect(url:String, cb:Function):void {
        CacheUtils0.loadClass(url, cb, "effect", SkillEffect0);
    }

    public static function loadPet(url:String, cb:Function):void {
        CacheUtils0.loadClass(url, cb, "pet", UI_Pet0.Pet0);
    }

    public static function loadMapContent(url:String, cb:Function):void {
        CacheUtils0.loadContent(url, cb, IconFallback);
    }

    public static function loadSkillSound(url:String, cb:Function):void {
        CacheUtils0.loadSound(url, cb, SkillSound0);
    }

    public static function loadPetSound(url:String, cb:Function):void {
        CacheUtils0.loadSound(url, cb, PetSound0);
    }

    public static function loadMapSound(url:String, cb:Function):void {
        CacheUtils0.loadSound(url, cb, MapSound0);
    }
}
}

import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.media.Sound;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import ui.Resource;

import utils.LRUCache;
import utils.Utils;

class CacheUtils0 {

    private static const waiting:Array = [];
    private static var loading:int = 0;

    private static function loadResourceNext():void {
        var next:* = waiting.shift();
        if (next) {
            loadResource(next.url, next.cb, next.onError);
        }
    }

    /**
     * 指定时间内未触发加载时快速失败
     */
    public static function loadResource(url:String, cb:Function, onError:Function = null):void {
        if (loading > 20) {
            waiting.push({url: url, cb: cb, onError: onError});
            return;
        }
        loading++;
        var flag:Boolean = false;

        function next():void {
            if (flag) {
                return;
            }
            flag = true;
            loading--;
            Utils.async(loadResourceNext);
            clearTimeout(timeout);
        }

        var loader:Loader = Utils.load(proxyHttp2Https(url), function (loaderInfo:LoaderInfo):void {
            if (flag) {
                return;
            }
            next();
            cb(loaderInfo);
        }, function (event:Event):void {
            if (flag) {
                return;
            }
            next();
            onError(event);
        });
        var timeout:uint = setTimeout(function ():void {
            if (flag) {
                return;
            }
            if (!loader.contentLoaderInfo.bytesLoaded) {
                next();
                onError(new Event("timeout"))
            }
        }, 500);
    }

    private static const CONTENT_CACHE:LRUCache = new LRUCache(1000);

    public static function loadContent(url:String, cb:Function, fallback:Class):void {
        if (!url) {
            cb(new fallback);
            return;
        }
        var exist:* = CONTENT_CACHE.get(url);
        if (exist) {
            cb(exist);
            return;
        }
        loadResource(url, function (loaderInfo:LoaderInfo):void {
            CONTENT_CACHE.put(url, loaderInfo.content);
            cb(loaderInfo.content);
        }, function ():void {
            cb(new fallback);
        });
    }

    private static const CLASS_CACHE:LRUCache = new LRUCache(1000);

    public static function loadClass(url:String, cb:Function, name:String, fallback:Class):void {
        if (!url) {
            cb(new fallback);
            return;
        }
        if (url.slice(0, Resource.MARK.length) === Resource.MARK) {
            var clazz:Class = Resource.clazz[url.slice(Resource.MARK.length)];
            if (clazz) {
                cb(new clazz);
                return;
            }
        }
        var exist:Class = CLASS_CACHE.get(url);
        if (exist) {
            cb(new exist);
            return;
        }
        loadResource(url, function (loaderInfo:LoaderInfo):void {
            var clazz:Class = loaderInfo.applicationDomain.getDefinition(name) as Class;
            CLASS_CACHE.put(url, clazz);
            cb(new clazz);
        }, function ():void {
            cb(new fallback);
        });
    }

    private static const SOUND_CACHE:LRUCache = new LRUCache(1000);

    public static function loadSound(url:String, cb:Function, fallback:Class):void {
        if (!url) {
            cb(new fallback);
            return;
        }
        var exist:Sound = SOUND_CACHE.get(url);
        if (exist) {
            cb(exist);
            return;
        }
        Utils.loadSound(proxyHttp2Https(url), function (sound:Sound):void {
            SOUND_CACHE.put(url, sound);
            cb(sound);
        }, function ():void {
            cb(new fallback);
        });
    }


    private static const S2_DOMAIN:String = "http://seer2.61.com/";
    private static const S2_PROXY:String = "https://seer2-proxy.netlify.app/proxy/";

    private static function proxyHttp2Https(url:String):String {
//        if (Config.isHttps && url.slice(0, S2_DOMAIN.length) === S2_DOMAIN) {
//            return S2_PROXY + url.slice(S2_DOMAIN.length)
//        }
        return url;
    }
}
