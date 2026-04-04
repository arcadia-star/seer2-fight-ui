package ui {
import ui.status.UI_FightFighterTraitX;
import ui.status.UI_WeatherIconN;

public class Resource {
    public static const clazz:Object = {};
    public static const MARK:String = "internal://";

    public static function init():void {
        for (var i:int = 0; i <= 23; i++) {
            clazz["UI_PetTypeIcon_" + i] = UI_PetTypeIcon_N.find(i);
        }
        for (i = 1; i <= 24; i++) {
            clazz["UI_WeatherIcon" + i] = UI_WeatherIconN.find(i);
        }
        clazz.UI_FightFighterTraitIncrease_Atk = UI_FightFighterTraitX.UI_FightFighterTraitIncrease_Atk;
        clazz.UI_FightFighterTraitIncrease_Defense = UI_FightFighterTraitX.UI_FightFighterTraitIncrease_Defense;
        clazz.UI_FightFighterTraitIncrease_SpecialAtk = UI_FightFighterTraitX.UI_FightFighterTraitIncrease_SpecialAtk;
        clazz.UI_FightFighterTraitIncrease_SpecialDefense = UI_FightFighterTraitX.UI_FightFighterTraitIncrease_SpecialDefense;
        clazz.UI_FightFighterTraitIncrease_Speed = UI_FightFighterTraitX.UI_FightFighterTraitIncrease_Speed;
        clazz.UI_FightFighterTraitDecrease_Atk = UI_FightFighterTraitX.UI_FightFighterTraitDecrease_Atk;
        clazz.UI_FightFighterTraitDecrease_Defense = UI_FightFighterTraitX.UI_FightFighterTraitDecrease_Defense;
        clazz.UI_FightFighterTraitDecrease_SpecialAtk = UI_FightFighterTraitX.UI_FightFighterTraitDecrease_SpecialAtk;
        clazz.UI_FightFighterTraitDecrease_SpecialDefense = UI_FightFighterTraitX.UI_FightFighterTraitDecrease_SpecialDefense;
        clazz.UI_FightFighterTraitDecrease_Speed = UI_FightFighterTraitX.UI_FightFighterTraitDecrease_Speed;
    }
}
}
