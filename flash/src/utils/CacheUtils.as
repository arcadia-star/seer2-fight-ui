package utils {
import flash.display.LoaderInfo;
import flash.media.Sound;

import ui.IconFallback;
import ui.Resource;
import ui.SkillEffect0;
import ui.UI_Pet0;
import ui.sound.MapSound0;
import ui.sound.PetSound0;
import ui.sound.SkillSound0;

public class CacheUtils {
    private static const RES_CACHE:LRUCache = new LRUCache(10000);

    public static function loadItem(url:String, cb:Function):void {
        load(url, cb, "item", IconFallback);
    }

    public static function loadEffect(url:String, cb:Function):void {
        load(url, cb, "effect", SkillEffect0);
    }

    public static function loadPet(url:String, cb:Function):void {
        load(url, cb, "pet", UI_Pet0);
    }

    private static function load(url:String, cb:Function, name:String, fallback:Class):void {
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
        var exist:Class = RES_CACHE.get(url);
        if (exist) {
            cb(new exist);
            return;
        }
        Utils.load(url, function (loaderInfo:LoaderInfo):void {
            var clazz:Class = loaderInfo.applicationDomain.getDefinition(name) as Class;
            RES_CACHE.put(url, clazz);
            cb(new clazz);
        }, function ():void {
            cb(new fallback);
        });
    }

    public static function loadContent(url:String, cb:Function):void {
        if (!url) {
            cb(new IconFallback);
            return;
        }
        Utils.load(url, function (loaderInfo:LoaderInfo):void {
            cb(loaderInfo.content);
        }, function ():void {
            cb(new IconFallback);
        });
    }

    public static function loadSkillSound(url:String, cb:Function):void {
        loadSound(url, cb, SkillSound0);
    }

    public static function loadPetSound(url:String, cb:Function):void {
        loadSound(url, cb, PetSound0);
    }

    public static function loadMapSound(url:String, cb:Function):void {
        loadSound(url, cb, MapSound0);
    }

    private static function loadSound(url:String, cb:Function, fallback:Class):void {
        if (!url) {
            cb(new fallback);
            return;
        }
        var exist:Sound = RES_CACHE.get(url);
        if (exist) {
            cb(exist);
            return;
        }
        Utils.loadSound(url, function (sound:Sound):void {
            RES_CACHE.put(url, sound);
            cb(sound);
        }, function ():void {
            cb(new fallback);
        });
    }
}
}
