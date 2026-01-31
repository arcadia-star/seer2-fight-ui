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

    private var currentMapSound:SoundChannel;
    private var currentMapSoundUrl:String;
    private static var _mapSoundTransform:SoundTransform = new SoundTransform(1);

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
            currentMapSound.soundTransform = _mapSoundTransform;
        });
    }

    public static function updateGlobalSound(sound:Number):void {
        SoundMixer.soundTransform = new SoundTransform(Math.min(sound, 1));
    }

    public static function updateMapSound(sound:Number):void {
        _mapSoundTransform.volume = Math.min(sound, 1);
    }
}
}
