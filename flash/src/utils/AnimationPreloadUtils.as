package utils {
public class AnimationPreloadUtils {

    public static function preloadPetAnimation(urlVec:Vector.<String>, maxTimeout:uint = 3000,doAfterEachSwfLoaded:Function = null,cb:Function = null):void {
        //预加载urlVec中的全部url. 为加载器设定超时时间maxTimeout. 每次加载完回调doAfterEachSwfLoaded, 全部加载完再调用一次cb
        var totalCb:Function = function(param:*):void {
            if(doAfterEachSwfLoaded) doAfterEachSwfLoaded(param);
            if(cb) cb();
        }
        for (var i:int = 0; i < urlVec.length - 1; ++i) {
            CacheUtils.loadPet(urlVec[i],doAfterEachSwfLoaded ? doAfterEachSwfLoaded : function(param:*):void{
            },maxTimeout);
        }
        CacheUtils.loadPet(urlVec[i],totalCb,maxTimeout);
    }

}
}
