import {
    ChangeFrame,
    Frame,
    FrameCommon,
    FrameFighter,
    FramePet,
    FrameSkill,
    FrameType,
    IdleFrame,
    MoveFrame,
    MoveSkillCategory
} from "@/frame.ts";

function random(max: number) {
    return Math.floor(Math.random() * (max + 1))
}

function arrayWithLen(len: number) {
    const array = [];
    for (let i = 0; i < len; i++) {
        array.push(i + 1)
    }
    return array;
}

function randomLenArray(len: number) {
    return arrayWithLen(random(len));
}

function randomInArray<T>(array: T[]) {
    return array[random(array.length - 1)];
}

function randomPet() {
    const pet: FramePet = {
        flash: `http://seer2.61.com/res/pet/fight/${random(1000)}.swf`,
        avatar: "/svg/demo-pet-avatar.svg",
        name: "不大长的名字",
        hp: random(500),
        hpMax: random(100) + 500,
        anger: random(50),
        angerMax: random(50) + 50,
        level: random(100),
        buffs: randomLenArray(10).map(() => ({
            icon: "/svg/demo-fight-buff.svg",
            tips: "demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff"
        })),
        petType: {
            icon: "/svg/demo-pet-type.svg",
            tips: "草"
        },
        petEmblem: {
            icon: "/svg/demo-pet-emblem.svg",
            tips: "pet emblem"
        },
        petEmblem2: {
            icon: "/svg/demo-pet-emblem.svg",
            tips: "pet emblem"
        },
        petFeature: {
            icon: "/svg/demo-pet-feature.svg",
            tips: "pet feature"
        },
        skills: [],
    };
    return pet;
}

function randomFighter() {
    const skills: FrameSkill[] = [
        {
            name: "俩字",
            category: "物理",
            tips: `吴丝蜀桐张高秋，空山凝云颓不流。
        江娥啼竹素女愁，李凭中国弹箜篌。
昆山玉碎凤凰叫，芙蓉泣露香兰笑。
十二门前融冷光，二十三丝动紫皇。
女娲炼石补天处，石破天惊逗秋雨。
梦入神山教神妪，老鱼跳波瘦蛟舞。
吴质不眠倚桂树，露脚斜飞湿寒兔。`
        }, {
            name: "三个字",
            category: "特殊",
            tips: "乐声清脆动听得就像昆仑山美玉击碎，凤凰鸣叫；时而像芙蓉在露水中饮泣，时而像香兰开怀欢笑。"
        }, {
            name: "四字弟弟",
            category: "属性",
            tips: "昆山玉碎凤凰叫：昆仑玉碎，形容乐音清脆。昆山：即昆仑山。凤凰叫：形容乐音和缓。芙蓉泣露、香兰笑：形容乐声时而低回，时而轻快。"
        }, {
            name: "五个字怎样",
            category: "必杀",
            tips: "“昆山”句是以声写声，着重表现乐声的起伏多变；“芙蓉”句则是以形写声，刻意渲染乐声的优美动听，用比喻的手法描绘了李凭弹奏箜篌的音乐特色。"
        }, {
            name: "最多有六个字",
            category: "合体",
            tips: "昆山玉碎凤凰叫，芙蓉泣露香兰笑。"
        }]
        .map(e => Object.assign({
            name: "最多有六个字",
            tips: "描述可以很长很长",
            category: "俩字",
            power: 100,
            anger: 100,
            type: {
                icon: "/svg/demo-pet-type.svg",
                tips: "草"
            },
        }, e))
    const fighter: FrameFighter = {
        master: randomPet(),
        skills,
        pets: randomLenArray(6).map(() => (randomPet())),
        capsules: randomLenArray(10).map(idx => ({
            icon: "/svg/demo-item-capsule.svg",
            tips: "capsule:" + idx,
            count: random(100),
        })),
        items: randomLenArray(10).map(idx => ({
            icon: "/svg/demo-item-hp.svg",
            tips: "item:" + idx,
            count: random(100),
        })),
    };
    return fighter;
}

function randomFrame() {
    const common: FrameCommon = {
        background: "/svg/demo-fight-bg.svg",
        round: 100,
        weather: {
            icon: "/svg/demo-fight-weather.svg",
            tips: "fight weather"
        },
    };

    const frame: IdleFrame = {
        left: randomFighter(),
        right: randomFighter(),
        common,
    };
    return frame;
}

function randomMoveFrame() {
    const start = randomFrame();
    const end = randomFrame();
    end.left.master.flash = start.left.master.flash;
    end.right.master.flash = start.right.master.flash;
    const frame: MoveFrame = {
        start,
        end,
        move: 1 + random(1),
        skillName: "技能的名字",
        skillCategory: randomInArray(Object.values(MoveSkillCategory)),
        damage: {
            hit: random(1),
            cri: random(1),
            rate: random(200),
            total: Math.pow(11, random(10))
        },
    };
    return frame;
}

function randomChangeFrame() {
    const start = randomFrame();
    const end = randomFrame();
    const frame: ChangeFrame = {
        start,
        end,
    };
    return frame;
}

export function randomFrames() {
    const fullFrames: Frame[] = arrayWithLen(1000).map((e) => {
        const type = randomInArray([FrameType.Move, FrameType.Change]);
        const data: ChangeFrame | MoveFrame = type == FrameType.Change ? randomChangeFrame() : randomMoveFrame();
        const frame = {
            type,
            data,
            logs: [],
            timestamp: Date.now() + e * 3000,
        };
        frame.data.start.common.round = e;
        frame.data.end.common.round = e;
        return frame;
    });
    for (let i = 1; i < fullFrames.length; i++) {
        const lastFrame = fullFrames[i - 1];
        const thisFrame = fullFrames[i];
        let endFrame: IdleFrame | null = null;
        if (lastFrame.type === FrameType.Move || lastFrame.type === FrameType.Change) {
            const frame = lastFrame.data as MoveFrame | ChangeFrame;
            endFrame = frame.end;
        }
        if (thisFrame.type === FrameType.Move || thisFrame.type === FrameType.Change) {
            const frame = thisFrame.data as MoveFrame | ChangeFrame;
            if (endFrame) {
                frame.start = endFrame;
            }
        }
    }
    return fullFrames;
}
