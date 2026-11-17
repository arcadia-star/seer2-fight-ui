package animation.status {
import data.pet.ArenaData;
import ui.status.UI_YuCunStatusLayout;

public class YuCunFightStatusPanel extends FightStatusPanel {
    private var _items:NormalPetItemBar;
    public function YuCunFightStatusPanel() {
        super(new UI_YuCunStatusLayout());
        _items=new NormalPetItemBar(_view["petItems"]);
    }
    override public function initData(data:ArenaData,smooth:int):void {
        super.initData(data,smooth);
        _items.initData(data.left.master.ext);
    }
}
}
