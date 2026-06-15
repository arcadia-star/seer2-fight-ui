package utils {
import flash.display.MovieClip;

public class AnimationPreloadUtils {

    /**
     * 预加载 urlVec 中的全部 url。
     * 每次加载完回调 doAfterEachSwfLoaded(pet)，全部加载完再调用一次 cb()。
     */
    public static function preloadPetAnimation(urlVec:Vector.<String>, maxTimeout:uint = 3000, doAfterEachSwfLoaded:Function = null, cb:Function = null):void {
        if (!urlVec || urlVec.length === 0) {
            if (cb) cb();
            return;
        }

        var remaining:int = urlVec.length;

        function onOneLoaded(pet:*):void {
            if (doAfterEachSwfLoaded) doAfterEachSwfLoaded(pet);
            remaining--;
            if (remaining === 0) {
                // 全部加载完成，针对每只动画预渲染特效量较大的帧
                for (var j:int = 0; j < urlVec.length; j++) {
                    preloadAndCacheFrames(urlVec[j]);
                }
                if (cb) cb();
            }
        }

        for (var i:int = 0; i < urlVec.length; i++) {
            CacheUtils.loadPet(urlVec[i], onOneLoaded, maxTimeout);
        }
    }

    /**
     * 针对已加载的某个 url，重新取一份"原始" MovieClip 实例并把它的帧预渲染到 FrameBitmapCache。
     * 重复调用对同一 url 是幂等的（FrameBitmapCache 内部已去重）。
     */
    public static function preloadAndCacheFrames(url:String):void {
        if (!url || FrameBitmapCache.has(url)) {
            return;
        }
        CacheUtils.loadPetRaw(url, function (pet:*):void {
            if (pet is MovieClip) {
                FrameBitmapCache.preload(url, pet as MovieClip);
            }
        });
    }
}
}