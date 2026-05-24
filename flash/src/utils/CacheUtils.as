package utils {
import animation.ext.ImgPet;
import animation.ext.S1Pet;

import flash.display.Bitmap;
import flash.display.MovieClip;
import flash.display.Sprite;

import ui.IconFallback;
import ui.PetFallback;
import ui.SkillEffect0;
import ui.UI_Map0;
import ui.sound.MapSound0;
import ui.sound.PetSound0;
import ui.sound.SkillSound0;

public class CacheUtils extends Sprite {
    public static const PET_EXT_S1:String = "ext-s1://";
    public static const EXT_IMAGE:String = "ext-img://";

    public static function loadItem(url:String, cb:Function):void {
        if (mayLoadAsExtImg(url, cb, IconFallback)) {
            return;
        }
        CacheUtils0.loadClass(url, cb, "item", IconFallback);
    }

    public static function loadEffect(url:String, cb:Function):void {
        CacheUtils0.loadClass(url, cb, "effect", SkillEffect0);
    }

    public static function loadPet(url:String, cb:Function):void {
        if (mayLoadAsExtImg(url, cb, PetFallback, ImgPet)) {
            return;
        }
        if (mayLoadAsExtPet(url, cb, PetFallback, S1Pet)) {
            return;
        }
        CacheUtils0.loadClass(url, cb, "pet", PetFallback);
    }

    public static function loadMapContent(url:String, cb:Function):void {
        if (mayLoadAsExtImg(url, cb, UI_Map0)) {
            return;
        }
        CacheUtils0.loadContent(url, cb, UI_Map0);
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

    private static function mayLoadAsExtImg(url:String, cb:Function, fallback:Class, wrapper:Class = null):Boolean {
        var EXT:String = EXT_IMAGE;
        if (url.slice(0, EXT.length) === EXT) {
            CacheUtils0.loadContent(url.slice(EXT.length), function (content:*):void {
                if (content is fallback) {
                    cb(content);
                    return;
                }
                var bitmap:Bitmap = new Bitmap(content.bitmapData.clone());
                cb(wrapper ? new wrapper(bitmap) : bitmap);
            }, fallback);
            return true;
        }
        return false;
    }

    private static function mayLoadAsExtPet(url:String, cb:Function, fallback:Class, wrapper:Class):Boolean {
        var EXT:String = PET_EXT_S1;
        if (url.slice(0, EXT.length) === EXT) {
            CacheUtils0.loadClass(url.slice(EXT.length), function (mc:MovieClip):void {
                if (mc is fallback) {
                    cb(mc);
                    return;
                }
                cb(new wrapper(mc));
            }, "pet", fallback);
            return true;
        }
        return false;
    }
}
}

import data.Config;

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

    private static const MAX_RESOURCE_LOADING:int = 8;
    private static const CONTENT_CACHE_SIZE:int = 80;
    private static const CLASS_CACHE_SIZE:int = 200;
    private static const SOUND_CACHE_SIZE:int = 80;

    private static const waiting:Array = [];
    private static var loading:int = 0;

    private static function loadResourceNext():void {
        var next:* = waiting.shift();
        if (next) {
            loadResource(next.url, next.cb, next.onError, next.max);
        }
    }

    /**
     * 指定时间内未触发加载时快速失败
     */
    public static function loadResource(url:String, cb:Function, onError:Function = null, max:int = MAX_RESOURCE_LOADING):void {
        if (loading >= max) {
            waiting.push({url: url, cb: cb, onError: onError, max: max});
            return;
        }
        loading++;
        var flag:Boolean = false;
        var loader:Loader;

        function next():void {
            if (flag) {
                return;
            }
            flag = true;
            loading--;
            Utils.async(loadResourceNext);
            clearTimeout(timeout);
        }

        function closeLoader():void {
            if (!loader) {
                return;
            }
            try {
                loader.close();
            } catch (e:*) {
                // ignore
            }
            try {
                loader.unloadAndStop(true);
            } catch (e2:*) {
                // ignore
            }
        }

        loader = Utils.load(proxyHttp2Https(url), function (loaderInfo:LoaderInfo):void {
            if (flag) {
                return;
            }
            next();
            cb(loaderInfo);
        }, function (event:Event):void {
            if (flag) {
                return;
            }
            closeLoader();
            next();
            onError && onError(event);
        });
        var timeout:uint = setTimeout(function ():void {
            if (flag) {
                return;
            }
            if (!loader.contentLoaderInfo.bytesLoaded) {
                closeLoader();
                next();
                onError && onError(new Event("timeout"))
            }
        }, 3000);
    }

    private static const CONTENT_CACHE:LRUCache = new LRUCache(CONTENT_CACHE_SIZE);

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

    private static const CLASS_CACHE:LRUCache = new LRUCache(CLASS_CACHE_SIZE);

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
            try {
                var clazz:Class = loaderInfo.applicationDomain.getDefinition(name) as Class;
                CLASS_CACHE.put(url, clazz);
                cb(new clazz);
                //加载失败走兜底逻辑
            } catch (e:Object) {
                cb(new fallback);
            }
        }, function ():void {
            cb(new fallback);
        });
    }

    private static const SOUND_CACHE:LRUCache = new LRUCache(SOUND_CACHE_SIZE);

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
    private static const S2_PROXY:String = "https://cdn.jsdelivr.net/gh/arcadia-star/seer2-origin-client@1.0.0/seer2.61.com/";
    private static const RES:String = "res/";

    private static function proxyHttp2Https(url:String):String {
        if (Config.redirectRes && url.slice(0, RES.length) === RES) {
            url = S2_DOMAIN + url;
        }
        if (Config.isHttps && url.slice(0, S2_DOMAIN.length) === S2_DOMAIN) {
            return S2_PROXY + url.slice(S2_DOMAIN.length)
        }
        return url;
    }
}
