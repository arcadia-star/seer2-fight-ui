package enums {
public class SkillCategoryName {

    public static const PHY:String = "物理";

    public static const SPE:String = "特殊";

    public static const BUF:String = "属性";

    public static const POW:String = "必杀";

    public static const POW_INTERCOURSE:String = "合体";

    public static function atkLabel(category:String):String {
        if (category === SkillCategoryName.PHY) {
            return FighterActionType.ATK_PHY;
        }
        if (category === SkillCategoryName.SPE) {
            return FighterActionType.ATK_SPE;
        }
        if (category === SkillCategoryName.BUF) {
            return FighterActionType.ATK_BUF;
        }
        if (category === SkillCategoryName.POW) {
            return FighterActionType.ATK_POW;
        }
        if (category === SkillCategoryName.POW_INTERCOURSE) {
            return FighterActionType.INTERCOURSE;
        }
        return FighterActionType.ATK_PHY;
    }

    public static function pow():Array {
        return [POW, POW_INTERCOURSE];
    }
}
}
