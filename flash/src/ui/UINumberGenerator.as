package ui {
import flash.display.Sprite;

import ui.number.UI_NumberAngerN;
import ui.number.UI_NumberAngerSlash;
import ui.number.UI_NumberHpN;
import ui.number.UI_NumberHpSlash;
import ui.number.UI_NumberItemN;
import ui.number.UI_NumberPetLevelN;

import utils.an.DisplayObjectUtil;

public class UINumberGenerator {

    public static function generateItemNumber(param1:int):Sprite {
        return generateNumberSprite(param1, UI_NumberItemN.find, 7);
    }

    public static function generateFighterLevelNumber(param1:int, param2:uint = 11):Sprite {
        return generateNumberSprite(param1, UI_NumberPetLevelN.find, param2);
    }

    public static function generateHpNumber(param1:int, param2:int):Sprite {
        //构造的Sprite,其x在斜杠的中心
        var _loc4_:Sprite = createDisableSprite();
        var _loc5_:Sprite = generateNumberSprite(param1, UI_NumberHpN.find, 11);
        _loc5_.x = -(_loc5_.width) - 6;
        _loc4_.addChild(_loc5_);
        var _loc6_:Sprite;
        _loc6_ = new UI_NumberHpSlash;
        _loc6_.x = -6;
        _loc4_.addChild(_loc6_);
        var _loc7_:Sprite;
        (_loc7_ = generateNumberSprite(param2, UI_NumberHpN.find, 11)).x = 6;
        _loc4_.addChild(_loc7_);
        return _loc4_;
    }

    public static function generateAngerNumber(param1:int, param2:int):Sprite {
        var _loc4_:Sprite = createDisableSprite();
        var _loc5_:Sprite = generateNumberSprite(param1, UI_NumberAngerN.find, 11);
        _loc5_.x = -(_loc5_.width) - 6;
        _loc4_.addChild(_loc5_);
        var _loc6_:Sprite;
        _loc6_ = new UI_NumberAngerSlash;
        _loc6_.x = -6;
        _loc4_.addChild(_loc6_);
        var _loc7_:Sprite;
        (_loc7_ = generateNumberSprite(param2, UI_NumberAngerN.find, 11)).x = 6;
        _loc4_.addChild(_loc7_);
        return _loc4_;
    }

    private static function generateNumberSprite(param1:int, param2:Function, param3:int):Sprite {
        var _loc7_:Sprite = null;
        var _loc5_:Sprite = createDisableSprite();
        var digits:String = Math.max(param1, 0).toString();
        var _loc8_:int = digits.length;
        var _loc9_:int = 0;
        while (_loc9_ < _loc8_) {
            (_loc7_ = new (param2(int(digits.charAt(_loc9_))))).x = _loc9_ * param3;
            _loc5_.addChild(_loc7_);
            _loc9_++;
        }
        return _loc5_;
    }

    private static function createDisableSprite():Sprite {
        var _loc1_:Sprite = new Sprite();
        DisplayObjectUtil.disableSprite(_loc1_);
        return _loc1_;
    }
}
}
