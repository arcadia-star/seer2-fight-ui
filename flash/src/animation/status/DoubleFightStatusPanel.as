package animation.status {
import ui.status.UI_DoubleStatusLayout;

public class DoubleFightStatusPanel extends FightStatusPanel {
    public function DoubleFightStatusPanel() {
        super(new UI_DoubleStatusLayout(),["leftSub","rightSub"]);
    }
}
}
