package data {
import flash.display.LoaderInfo;
import flash.display.Sprite;

public class Config {
    public var jsCallback:String;
    public var leftUrl:String;
    public var rightUrl:String;
    public var silence:Boolean;
    public var loading:Boolean;
    public var playUrl:String;
    public static var isHttps:Boolean;

    public static function from(source:Sprite):Config {
        var config:Config = new Config();
        var loaderInfo:LoaderInfo = LoaderInfo(source.root.loaderInfo);
        var params:Object = loaderInfo.parameters;
        config.jsCallback = params["cb"] || "flash_dispatch";
        config.leftUrl = params["url"] || '';
        config.rightUrl = params["url2"] || '';
        config.silence = params["silence"] || false;
        config.loading = params["loading"] || false;
        config.playUrl = params["playUrl"];
        isHttps = loaderInfo.loaderURL.slice(0, "https://".length) === "https://";
        return config;
    }
}
}
