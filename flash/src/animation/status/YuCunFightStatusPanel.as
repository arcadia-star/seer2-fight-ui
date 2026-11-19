package animation.status {
import data.pet.ArenaData;

[Embed(source="/_assets/battle-ui.swf", symbol="UI_YuCunStatusLayout")]
public dynamic class YuCunFightStatusPanel extends FightStatusPanel {
    public var petItems:NormalPetItemBar;

    override public function initData(data:ArenaData, smooth:int):void {
        super.initData(data, smooth);
        petItems.initData(data.left.master.ext);
    }
}
}
