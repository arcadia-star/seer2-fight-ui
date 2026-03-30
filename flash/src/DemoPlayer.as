package {
import animation.event.Events;
import animation.event.OperateEvent;
import animation.layer.AlertLayer;

import data.Config;
import data.pet.ChangeData;
import data.pet.EndData;
import data.pet.EventData;
import data.pet.FrameData;
import data.pet.FramesData;
import data.pet.MoveData;
import data.pet.PetData;
import data.pet.SkillData;
import data.pet.TeamData;

import flash.display.Sprite;
import flash.events.Event;

import ui.Resource;

import utils.NumberUtil;
import utils.Utils;

[SWF(width="1200", height="660", frameRate="24")]
public class DemoPlayer extends Sprite {
    private var config:Config;

    private var framePlayer:FramePlayer;
    private var alertLayer:AlertLayer;

    public function DemoPlayer() {
        Resource.init();

        this.config = Config.from(this);
        this.framePlayer = new FramePlayer();
        this.alertLayer = new AlertLayer();
        addChild(framePlayer);
        addChild(alertLayer);

        play()
    }

    private function play():void {
        var frame:FrameData;
        Utils.loadText(config.playUrl || "../../public/demo/mock.json", function (data:String):void {
            var framesData:FramesData = FramesData.from(Utils.jsonParse(data));
            framePlayer.updateUiStyle(framesData.uiStyle);
            framePlayer.updateGlobalSound(framesData.globalVolume / 100);
            framePlayer.updateMapSound(framesData.mapVolume / 100);
            frame = framesData.frames[0];
            var seedPet:PetData = frame.data.left.master;

            function randomPet(pid:int):PetData {
                var pet:PetData = PetData.clone(seedPet);
                var number:Number = NumberUtil.random(1, 1000);
                pet.pid = pid;
                pet.name = "R" + number;
                pet.position = 0;
                pet.petIcon = "http://seer2.61.com/res/pet/icon/" + number + ".swf";
                pet.petSwf = "http://seer2.61.com/res/pet/fight/" + number + ".swf";
                return pet;
            }

            frame.data.left.pets = new Vector.<PetData>();
            frame.data.left.pets.push(seedPet);
            frame.data.left.pets.push(randomPet(101));
            frame.data.left.pets.push(randomPet(102));
            frame.data.left.pets.push(randomPet(103));
            frame.data.left.pets.push(randomPet(104));
            frame.data.left.pets[0].position = 1;
            frame.data.left.pets[1].position = 2;
            frame.data.left.init();

            function frameClear():void {
                frame.move = null;
                frame.change = null;
                frame.event = null;
                frame.start = null;
                frame.end = null;
                frame.sleep = 0;
                frame.logs = null;
            }

            framePlayer.playFrame(FrameData.clone(frame), function ():void {

            });
            framePlayer.addEventListener(OperateEvent.OPERATE_END, function (event:OperateEvent):void {
                if (event.data.skill > 0) {
                    frame.data.round++;
                    var skills:Vector.<SkillData> = frame.data.left.master.skills;
                    var skill:SkillData = skills.filter(function (e:SkillData, a:uint, b:uint):Boolean {
                        return e.id === event.data.skill;
                    })[0];
                    var moveData:MoveData = new MoveData;
                    moveData.side = 1;
                    moveData.skill = skill.name;
                    moveData.category = skill.category.replace("_", "");
                    moveData.damage = 9999;
                    moveData.critical = Math.random() > 0.5 ? 1 : 0;
                    moveData.miss = Math.random() > 0.9 ? 1 : 0;
                    moveData.rate = Math.random() > 0.5 ? 200 : 100;
                    moveData.soundUrl = "http://seer2.61.com/res/skill/sound/12_3_002.mp3";
                    moveData.effectUrl = "http://seer2.61.com/res/skill/effect/12_1_003.swf";

                    frameClear();
                    frame.move = moveData;
                    frame.data.right.master.hp -= 100;
                    frame.data.right.master.anger += 20;
                    var frameData:FrameData = FrameData.clone(frame);
                    frameData.logs = new Vector.<String>();
                    frameData.logs.push("<font color=\'#ffffff\'>[" + frame.data.round + "]</font><font color=\'#00ffff\'>" + frame.data.left.master.name + "</font><font color=\'#ffffff\'>使用技能</font><font color=\'#ffff00\'>" + skill.name + "</font>");
                    framePlayer.playFrame(frameData, function ():void {
                        frame.move.side = 2;
                        frame.data.left.master.hp -= 100;
                        frame.data.left.master.anger += 20;
                        var frameData:FrameData = FrameData.clone(frame);
                        frameData.logs = new Vector.<String>();
                        frameData.logs.push("<font color=\'#ffffff\'>[" + frame.data.round + "]</font><font color=\'#00ffff\'>" + frame.data.right.master.name + "</font><font color=\'#ffffff\'>使用技能</font><font color=\'#ffff00\'>" + skill.name + "</font>");
                        framePlayer.playFrame(frameData, function ():void {
                        });
                    });
                }
                if (event.data.pet > 0) {
                    var team:TeamData = frame.data.left;
                    for (var i:int = 0; i < team.pets.length; i++) {
                        var pet:PetData = team.pets[i];
                        if (pet.pid === event.data.pet) {
                            pet.position = 1;
                        } else if (pet.position === 1) {
                            pet.position = 0;
                        }
                    }
                    team.init();
                    frameClear();
                    frame.change = new ChangeData();
                    frame.change.left = 1;
                    framePlayer.playFrame(FrameData.clone(frame), function ():void {

                    });
                }
                if (event.data.item > 0 || event.data.capsule > 0) {
                    var typ:uint = event.data.item || event.data.capsule;
                    frameClear();
                    frame.event = new EventData();
                    frame.event.side = 1;
                    frame.event.type = typ;
                    frame.event.change = NumberUtil.random(1, 10000);
                    frame.event.delay = 500;
                    framePlayer.playFrame(FrameData.clone(frame), function ():void {
                        if (typ === EventData.CATCH_SUCCESS) {
                            frameClear();
                            frame.end = new EndData();
                            frame.end.winner = 2;
                            framePlayer.playFrame(FrameData.clone(frame), function ():void {
                            });
                        }
                    });
                }
                if (event.data.escape > 0) {
                    alertLayer.confirm("确定要逃跑吗", function ():void {
                        alertLayer.select("随便选一个吧", [
                            {name: 'First', url: 'http://seer2.61.com/res/item/medal/icon/500004.swf'},
                            {name: 'Second', url: 'http://seer2.61.com/res/item/medal/icon/500005.swf'}
                        ]);
                    });
                }
            });

            framePlayer.addEventListener(Events.BTN_MORPH_CLICK, function (event:Event):void {
                event.stopImmediatePropagation();
                frameClear();
//                frame.change = new ChangeData();
//                frame.change.left = 2;
//                if (frame.data.left.pets[0].petSwf === "http://seer2.61.com/res/pet/fight/946.swf") {
//                    frame.data.left.pets[0].petSwf = "http://seer2.61.com/res/pet/fight/947.swf"
//                } else if (frame.data.left.pets[0].petSwf === "http://seer2.61.com/res/pet/fight/947.swf") {
//                    frame.data.left.pets[0].petSwf = "http://seer2.61.com/res/pet/fight/946.swf"
//                }
                frame.event = new EventData();
                frame.event.type = EventData.PET_EXCHANGE;
                frame.data.left.master.position = 2;
                frame.data.left.slave.position = 1;
                frame.data.left.init();
                framePlayer.playFrame(FrameData.clone(frame), function ():void {

                });
            })
        });
    }
}
}
