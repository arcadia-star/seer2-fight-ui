package animation.status {
import data.pet.ArenaData;

import utils.an.DisplayUtil;

public class YuCunFightStatusPanel extends SPTFightStatusPanel {

    private var _petBar:PetIconBar;
    private var _itemBar:PetItemBar

    public function YuCunFightStatusPanel() {
    }

    override public function initData(param1:ArenaData, param2:int):void {
        super.initData(param1, param2);
        this._petBar.initData(param1.left.pets);
        this._itemBar.initData(param1.left.master.ext);
    }

    override protected function createChildren():void {
        super.createChildren();
        _petBar = new PetIconBar();
        addChild(_petBar);
        _itemBar = new PetItemBar();
        addChild(_itemBar);
    }

    override protected function layout():void {
        super.layout();
        var setChildPosition:Function = DisplayUtil.setChildPosition;
        setChildPosition(_petBar, 10, 54 * 3);
        setChildPosition(_itemBar, 170, 15);
    }
}
}

import animation.common.IconDisplay;
import animation.common.TipsDisplay;

import data.pet.PetData;

import data.pet.PetExtData;

import flash.display.Sprite;

import ui.Resource;

import utils.an.DisplayObjectUtil;

class PetItemBar extends Sprite {
    private var _sexIcon:IconDisplay;
    private var _featureIcon:IconDisplay;
    private var _emblem1Icon:IconDisplay;
    private var _emblem2Icon:IconDisplay;
    private var _fetterIcon:IconDisplay;
    private var _morphIcon:IconDisplay;
    private var _data:PetExtData;

    [Embed(source="/_assets/yucun/合体.swf", symbol="item")]
    public static var sex0:Class;
    [Embed(source="/_assets/yucun/雄性.swf", symbol="item")]
    public static var sex1:Class;
    [Embed(source="/_assets/yucun/雌性.swf", symbol="item")]
    public static var sex2:Class;
    [Embed(source="/_assets/yucun/特性.swf", symbol="item")]
    public static var feature0:Class;
    [Embed(source="/_assets/yucun/白纹章.swf", symbol="item")]
    public static var emblem1:Class;
    [Embed(source="/_assets/yucun/黑纹章.swf", symbol="item")]
    public static var emblem2:Class;
    [Embed(source="/_assets/yucun/羁绊.swf", symbol="item")]
    public static var fetter0:Class;
    [Embed(source="/_assets/yucun/变身.swf", symbol="item")]
    public static var morph0:Class;
    {
        Resource.clazz["UI_ext_sex0"] = sex0;
        Resource.clazz["UI_ext_sex1"] = sex1;
        Resource.clazz["UI_ext_sex2"] = sex2;
        Resource.clazz["UI_ext_feature0"] = feature0;
        Resource.clazz["UI_ext_emblem1"] = emblem1;
        Resource.clazz["UI_ext_emblem2"] = emblem2;
        Resource.clazz["UI_ext_fetter0"] = fetter0;
        Resource.clazz["UI_ext_morph0"] = morph0;
    }


    public function initData(data:PetExtData):void {
        if (_data && data
                && _data.sex === data.sex
                && _data.featureTips === data.featureTips
                && _data.emblem1 === data.emblem1
                && _data.emblem1Tips === data.emblem1Tips
                && _data.emblem2 === data.emblem2
                && _data.emblem2Tips === data.emblem2Tips
                && _data.fetterTips === data.fetterTips
                && _data.morphTips === data.morphTips
        ) {
            return;
        }
        DisplayObjectUtil.removeAllChildren(this);

        _data = data;
        if (!data) {
            return;
        }

        var x:int = 0;

        _sexIcon = new IconDisplay();
        _sexIcon.initData("internal://UI_ext_sex" + (data.sex > 2 ? 0 : data.sex));
        _sexIcon.x = x;
        addChild(_sexIcon);
        x += 30;

        if (data.featureTips) {
            _featureIcon = new IconDisplay();
            _featureIcon.initData("internal://UI_ext_feature0");
            var tips:TipsDisplay;
            tips = new TipsDisplay(_featureIcon);
            tips.x = x;
            tips.y = 5;
            tips.initData(data.featureTips);
            addChild(tips);
            x += 45;
        }

        if (data.emblem1Tips) {
            _emblem1Icon = new IconDisplay();
            _emblem1Icon.initData(data.emblem1 ? "internal://UI_ext_emblem1" : "internal://UI_ext_emblem2");
            tips = new TipsDisplay(_emblem1Icon);
            tips.x = x;
            tips.initData(data.emblem1Tips);
            addChild(tips);
            x += 30;
        }

        if (data.emblem2Tips) {
            _emblem2Icon = new IconDisplay();
            _emblem2Icon.initData(data.emblem2 ? "internal://UI_ext_emblem1" : "internal://UI_ext_emblem2");
            tips = new TipsDisplay(_emblem2Icon);
            tips.x = x;
            tips.initData(data.emblem2Tips);
            addChild(tips);
            x += 30;
        }

        if (data.fetterTips) {
            _fetterIcon = new IconDisplay();
            _fetterIcon.initData("internal://UI_ext_fetter0");
            tips = new TipsDisplay(_fetterIcon);
            tips.x = x;
            tips.initData(data.fetterTips);
            addChild(tips);
            x += 30;
        }

        if (data.morphTips) {
            _morphIcon = new IconDisplay();
            _morphIcon.initData("internal://UI_ext_morph0");
            tips = new TipsDisplay(_morphIcon);
            tips.x = x;
            tips.initData(data.morphTips);
            addChild(tips);
        }
    }
}
class PetIconBar extends Sprite {
    [Embed(source="/_assets/yucun/头像框.swf", symbol="item")]
    public static var petIcon0:Class;
    [Embed(source="/_assets/yucun/问号.swf", symbol="item")]
    public static var petIcon1:Class;
    {
        Resource.clazz["UI_ext_petIcon0"] = petIcon0;
        Resource.clazz["UI_ext_petIcon1"] = petIcon1;
    }

    private var _petsIcons:Vector.<IconDisplay>;

    public function PetIconBar() {
        _petsIcons = new Vector.<IconDisplay>();
        for (var i:int = 0; i < 6; i++) {
            var petIconDisplay:IconDisplay = new IconDisplay();
            petIconDisplay.setSize(32);
            petIconDisplay.x = 0;
            petIconDisplay.y = i * 32;
            addChild(petIconDisplay);
            _petsIcons[i] = petIconDisplay;
        }
    }

    public function initData(pets:Vector.<PetData>):void {
        for (var i:int = 0; i < _petsIcons.length; i++) {
            var iconDisplay:IconDisplay = _petsIcons[i];
            if (i < pets.length) {
                var pet:PetData = pets[i];
                if (pet.ext && pet.ext.showIcon) {
                    iconDisplay.initData(pet.petIcon);
                } else {
                    iconDisplay.initData("internal://UI_ext_petIcon1");
                }
            } else {
                iconDisplay.initData("internal://UI_ext_petIcon0");
            }
        }
    }
}