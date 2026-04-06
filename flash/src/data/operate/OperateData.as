package data.operate {
public class OperateData {
    public static const FUNCTIONAL_CHANGE_UI:int = 1;

    public var skill:uint;
    public var pet:uint;
    public var item:uint;
    public var capsule:uint;
    public var escape:uint;
    public var functional:uint;

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
