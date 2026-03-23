package animation.status {

import data.pet.BuffData;
import data.pet.ItemData;
import data.pet.PetData;

import enums.FightSide;

import flash.display.Sprite;

import utils.an.DisplayObjectUtil;
import utils.ds.HashMap;

internal class BuffIconBar extends Sprite {

    private static const ICON_WIDTH:int = 32;

    private var _side:int;

    private var _maxLine:uint;

    private var _direction:int;

    private var _iconMap:HashMap;

    private var _iconMap2:HashMap;

    private var _iconMap3:HashMap;

    public function BuffIconBar(param1:int, param2:uint = 10) {
        super();
        this._side = param1;
        this._maxLine = param2;
        this._iconMap = new HashMap();
        this._iconMap2 = new HashMap();
        this._iconMap3 = new HashMap();
        if (this._side == FightSide.LEFT) {
            this._direction = 1;
        } else {
            this._direction = -1;
        }
    }

    public function initData(param1:PetData):void {
        DisplayObjectUtil.removeAllChildren(this);
        var buffs:Vector.<BuffData> = param1.buffs;
        var itemBuffs:Vector.<BuffData> = buildItemBuffs(param1.items);
        var lvBuffs:Vector.<BuffData> = buildLvBuffs(param1);
        for (var idx:int = 0; idx < buffs.length + itemBuffs.length + lvBuffs.length; idx++) {
            var buff:BuffData;
            var buffIcon:BuffIcon
            if (idx < lvBuffs.length) {
                buff = lvBuffs[idx];
                if (!_iconMap2.containsKey(buff.id)) {
                    _iconMap2.add(buff.id, new BuffIcon());
                }
                buffIcon = _iconMap2.getValue(buff.id);
                buffIcon.setShowNumMin(1);
            } else if (idx < itemBuffs.length + lvBuffs.length) {
                buff = itemBuffs[idx - lvBuffs.length];
                if (!_iconMap3.containsKey(buff.id)) {
                    _iconMap3.add(buff.id, new BuffIcon());
                }
                buffIcon = _iconMap3.getValue(buff.id);
            } else {
                buff = buffs[idx - itemBuffs.length - lvBuffs.length];
                if (!_iconMap.containsKey(buff.id)) {
                    _iconMap.add(buff.id, new BuffIcon());
                }
                buffIcon = _iconMap.getValue(buff.id);
            }
            if (idx >= this._maxLine) {
                buffIcon.x = (idx % this._maxLine) * this._direction * ICON_WIDTH;
                buffIcon.y = int(idx / this._maxLine) * (ICON_WIDTH + 2);
            } else {
                buffIcon.x = idx * this._direction * ICON_WIDTH;
                buffIcon.y = 0;
            }
            buffIcon.initData(buff);
            addChild(buffIcon);
        }
    }

    private function buildLvBuffs(param1:PetData):Vector.<BuffData> {
        const TRAIT_ATK:uint = 10001;
        const TRAIT_DEFENCE:uint = 10002;
        const TRAIT_SPECIAL_ATK:uint = 10003;
        const TRAIT_SPECIAL_DEFENCE:uint = 10004;
        const TRAIT_SPEED:uint = 10005;
        var buffs:Vector.<BuffData> = new Vector.<BuffData>();

        function add(id:int, name:String, typ:String, count:int):void {
            if (count !== 0) {
                var buff:BuffData = new BuffData();
                buff.id = id;
                buff.name = name + (count > 0 ? "强化" : "弱化");
                buff.icon = "internal://UI_FightFighterTrait" + (count > 0 ? "Increase" : "Decrease") + "_" + typ;
                buff.tips = ""
                buff.count = count > 0 ? count : -count;
                buffs.push(buff);
            }
        }

        add(TRAIT_ATK, "物攻", "Atk", param1.atk);
        add(TRAIT_DEFENCE, "物防", "Defense", param1.def);
        add(TRAIT_SPECIAL_ATK, "特攻", "SpecialAtk", param1.spa);
        add(TRAIT_SPECIAL_DEFENCE, "特防", "SpecialDefense", param1.spd);
        add(TRAIT_SPEED, "速度", "Speed", param1.spe);
        return buffs;
    }

    private function buildItemBuffs(param1:Vector.<ItemData>):Vector.<BuffData> {
        var res:Vector.<BuffData> = new Vector.<BuffData>();
        if (!param1) {
            return res;
        }
        for (var i:int = 0; i < param1.length; i++) {
            res.push(buildItemBuff(param1[i]));
        }
        return res;
    }

    private function buildItemBuff(obj:ItemData):BuffData {
        var target:BuffData = new BuffData();
        target.id = obj.id;
        target.name = obj.name;
        target.icon = obj.icon
        target.tips = obj.tips
        target.count = obj.count
        return target;
    }
}
}
