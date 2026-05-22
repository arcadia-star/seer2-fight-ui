package data.operate {
public class OperateData {
    public static const FUNCTIONAL_CHANGE_UI:int = 1;
    public static const FUNCTIONAL_AUTO_FIGHT:int = 2;
    public static const FUNCTIONAL_SETTING:int = 3;

    public var skill:int;
    public var pet:int;
    public var item:int;
    public var capsule:int;
    public var escape:int;
    public var functional:int;

    public function toObject():* {
        return {
            skill: this.skill,
            pet: this.pet,
            item: this.item,
            capsule: this.capsule,
            escape: this.escape,
            functional: this.functional
        }
    }
}
}
