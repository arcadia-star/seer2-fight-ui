package data.pet {
public class FramesData {
    public var globalVolume:int;
    public var mapVolume:int;
    public var frames:Vector.<FrameData>;

    public static function from(obj:Object):FramesData {
        var target:FramesData = new FramesData;
        target.globalVolume = obj.globalVolume;
        target.mapVolume = obj.mapVolume;
        target.frames = transFrame(obj.frames);
        return target;
    }

    private static function transFrame(array:Array):Vector.<FrameData> {
        var res:Vector.<FrameData> = new Vector.<FrameData>();
        if (!array) {
            return res;
        }
        for (var i:int = 0; i < array.length; i++) {
            res.push(FrameData.from(array[i]));
        }
        return res;
    }

}
}
