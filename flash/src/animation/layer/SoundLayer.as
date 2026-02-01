package animation.layer {
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundMixer;
import flash.media.SoundTransform;

import utils.CacheUtils;

public class SoundLayer {
    private var currentSkillSound:SoundChannel;
    private var currentSkillSoundUrl:String;

    public function playSkillSound(url:String):void {
        function clearSound():void {
            if (currentSkillSound) {
                currentSkillSound.stop();
                currentSkillSound = null;
            }
        }

        clearSound();
        currentSkillSoundUrl = url;
        if (!url) {
            return;
        }
        CacheUtils.loadSkillSound(url, function (sound:Sound):void {
            if (currentSkillSoundUrl !== url) {
                return
            }
            clearSound();
            currentSkillSound = sound.play();
        });
    }

    private var currentPetSound:SoundChannel;
    private var currentPetSoundUrl:String;

    public function playPetSound(url:String):void {
        function clearSound():void {
            if (currentPetSound) {
                currentPetSound.stop();
                currentPetSound = null;
            }
        }

        clearSound();
        currentPetSoundUrl = url;
        if (!url) {
            return;
        }
        CacheUtils.loadPetSound(url, function (sound:Sound):void {
            if (currentPetSoundUrl !== url) {
                return
            }
            clearSound();
            currentPetSound = sound.play();
        });
    }

    private static var currentMapSound:SoundChannel;
    private static var currentMapSoundUrl:String;
    private static var _globalSound:Number;
    private static var _mapSound:Number;

    public function playMapSound(url:String):void {
        function clearSound():void {
            if (currentMapSound) {
                currentMapSound.stop();
                currentMapSound = null;
            }
        }

        if (currentMapSoundUrl === url) {
            return;
        }
        currentMapSoundUrl = url;
        if (!url) {
            return;
        }
        CacheUtils.loadMapSound(url, function (sound:Sound):void {
            if (currentMapSoundUrl !== url) {
                return
            }
            clearSound();
            currentMapSound = sound.play();
            currentMapSound.soundTransform = new SoundTransform(_mapSound);
        });
    }

    public static function updateGlobalSound(sound:Number):void {
        sound = Math.max(Math.min(sound, 1), 0);
        if (sound === _globalSound) {
            return;
        }
        _globalSound = sound;
        SoundMixer.soundTransform = new SoundTransform(_globalSound);
    }

    public static function updateMapSound(sound:Number):void {
        sound = Math.max(Math.min(sound, 1), 0);
        if (sound === _mapSound) {
            return;
        }
        _mapSound = sound;
        if (!currentMapSound) {
            return;
        }
        currentMapSound.soundTransform = new SoundTransform(_mapSound);
    }
}
}
