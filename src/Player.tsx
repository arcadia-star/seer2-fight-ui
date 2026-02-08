import {FightPlayer} from "@/player/fight-player.tsx";
import {useEffect, useRef, useState} from "react";
import {RufflePlayerEl} from "@/components/ruffle-player.tsx";
import init, {
    ArenaProxy,
    ArenaResultDTO,
    BuffResultDTO,
    FrameResultDTO,
    PetResultDTO,
    SkillResultDTO,
    TeamResultDTO
} from "@/_fight/arena_proxy";
import {Arena, Buff, Frame, Frames, MoveCategory, Pet, Skill, Team} from "@/types.ts";

const wasmInit = init({module_or_path: "_fight/arena_proxy_bg.wasm"});


function toSkill(skill: SkillResultDTO): Skill {
    return {
        id: skill.skill,
        name: "" + skill.skill,
        power: skill.power,
        anger: skill.anger,
        category: "",
        typeIcon: "",
        tips: "",
        enable: true,
    }
}

function toBuff(buff: BuffResultDTO): Buff {
    return {
        id: buff.buff,
        name: "" + buff.buff,
        count: buff.count,
        icon: "1",
        tips: "",
    }
}

function toPet(pet: PetResultDTO): Pet {
    return {
        pid: pet.pid,
        petIcon: "http://seer2.61.com/res/pet/icon/" + pet.monster + ".swf",
        petSwf: "http://seer2.61.com/res/pet/fight/" + pet.monster + ".swf",
        petSound: "",
        name: "",
        level: pet.level,
        typeIcon: "internal://UI_PetTypeIcon_" + pet.type,
        position: 1,
        alive: pet.alive,
        anger: pet.anger,
        maxAnger: 100,
        hp: pet.hp,
        maxHp: pet.hpMax,
        rate: 100,
        atk: pet.atk.level,
        def: pet.def.level,
        spa: pet.spa.level,
        spd: pet.spd.level,
        spe: pet.spe.level,
        skills: pet.skills.map(toSkill),
        buffs: pet.buffs.map(toBuff),
    }
}

function toTeam(team: TeamResultDTO): Team {
    return {
        pets: [toPet(team.master)],
        items: [],
        capsules: [],
    }
}

function toArena(arena: ArenaResultDTO): Arena {
    return {
        left: toTeam(arena.left),
        right: toTeam(arena.right),
        round: arena.round,
        mapSwf: "http://seer2.61.com/res/map/swf/100015.swf",
        mapSound: "http://seer2.61.com/res/map/sound/BGM_1002.mp3",
        weatherIcon: arena.weather > 0 ? ("internal://UI_WeatherIcon" + arena.weather) : "",
        weatherTips: "",
    }
}

function toFrame(frame: FrameResultDTO): Frame {
    if (frame.type === 'MoveEnd') {
        const moveEvent = frame.events
            .map(e => e.event)
            .find(e => e.$ === 'Move');
        const hurtEvent = frame.events
            .map(e => e.event)
            .filter(e => e.$ === 'Hurt')
            .find(e => e?.type?.$ === 'Attack');
        if (moveEvent && hurtEvent) {
            const attack = hurtEvent.type;
            if (attack.$ === 'Attack') {
                const ext = attack.ext;
                return {
                    move: {
                        side: frame.arena.left.master.pid === moveEvent.pid ? 1 : 2,
                        skill: "",
                        category: MoveCategory.Physical,
                        damage: hurtEvent.damage,
                        critical: ext.crit,
                        miss: 0,
                        rate: ext.rate,
                        soundUrl: "http://seer2.61.com/res/skill/sound/02_1_003.mp3",
                        effectUrl: "http://seer2.61.com/res/skill/effect/02_1_003.swf"
                    },
                    data: toArena(frame.arena)
                }
            }
        }
    }
    return {
        data: toArena(frame.arena)
    }
}

export function Player() {
    const ruffleRef = useRef<RufflePlayerEl>(null);
    const onOperate = function (event) {
        const arena = arenaRef.current;
        if (!arena) {
            return;
        }
        const skill = event.skill;
        if (skill) {
            arena.user_select_skill(101, skill, 201);
            arena.user_select_skill(201, skill, 101);
            const res = arena.fight();
            console.debug(res);
            setData({
                ...data,
                frames: data.frames?.concat(res.frames.map(toFrame))
            });
        }
    };
    const [idx, setIdx] = useState(0);
    const [data, setData] = useState<Frames>({
        globalVolume: 100,
        mapVolume: 100,
        frames: []
    });
    const arenaRef = useRef<ArenaProxy>(null);
    useEffect(() => {
        wasmInit.then(() => {
            console.debug(ArenaProxy.meta());
            arenaRef.current = new ArenaProxy(mockData, mockConfig);
            const arena = arenaRef.current;
            const res = arena.ready();
            setData({
                ...data,
                frames: data.frames?.concat(res.frames.map(toFrame))
            });
        });
    }, []);

    return <FightPlayer ruffleRef={ruffleRef} frames={data}
                        idx={idx} onChangeIdx={setIdx} onOperate={onOperate}/>
}

const mockData = {
    arena: {
        weather: 0,
        timestamp: 1,
    },
    left: {
        user: {
            uid: 0,
            nick: "",
        },
        pets: [
            {
                pet: 1,
                monster: 3,
                character: 66,
                level: 100,
                skills: [
                    10011
                ],
                iv: {
                    hp: 120,
                    atk: 120,
                    def: 120,
                    spa: 120,
                    spd: 120,
                    spe: 120
                },
                ev: {
                    hp: 255,
                    atk: 255,
                    def: 255,
                    spa: 255,
                    spd: 255,
                    spe: 255
                },
                emblem1: 0,
                emblem2: 0,
                hp: 0,
                maxhp: 0,
                height: 0,
                weight: 0,
                items: [
                    {
                        item: 10001
                    }
                ]
            }
        ]
    },
    right: {
        user: {
            uid: 0,
            nick: "",
        },
        pets: [
            {
                pet: 1,
                monster: 6,
                character: 66,
                level: 100,
                skills: [
                    10027
                ],
                iv: {
                    hp: 120,
                    atk: 120,
                    def: 120,
                    spa: 120,
                    spd: 120,
                    spe: 120
                },
                ev: {
                    hp: 255,
                    atk: 255,
                    def: 255,
                    spa: 255,
                    spd: 255,
                    spe: 255
                },
                emblem1: 0,
                emblem2: 0,
                hp: 0,
                maxhp: 0,
                height: 0,
                weight: 0,
                items: []
            }
        ]
    }
};
const mockConfig = {
    monsters: [
        {
            id: 3,
            name: "迪兰特",
            feature: 0,
            type: 3,
            hp: 185,
            atk: 116,
            def: 114,
            spa: 135,
            spd: 121,
            spe: 105,
            skills: [],
        },
        {
            id: 6,
            name: "休罗斯",
            feature: 0,
            type: 4,
            hp: 179,
            atk: 140,
            def: 111,
            spa: 112,
            spd: 110,
            spe: 120,
            skills: []
        }
    ],
    characters: [
        {
            id: 66,
            name: "六冷",
            hp: 110,
            atk: 110,
            def: 110,
            spa: 110,
            spd: 110,
            spe: 110,
        }
    ],
    skills: [
        {
            id: 10011,
            name: "飞流瀑布",
            tips: "【💠】清空弱点记号 每个增加50点威力",
            power: 100,
            anger: 15,
            type: 3,
            category: 2,
            accuracy: 95,
            critical: 5,
            times: 1,
            priority: 0,
            effects: [
                {
                    hook: "ThisSkillPower",
                    order: 0,
                    effect: "attrMul(1)",
                },
                {
                    hook: "Moving",
                    order: 1400,
                    effect: "1&&_if(round()==1,attachBuff(2,1))",
                },
                {
                    hook: "Moving",
                    order: 1400,
//          effect: "speLevelSub(2,1)",
                    effect: "weatherSet(1)",
                }
            ]
        },
        {
            id: 10027,
            name: "怒火猛攻",
            tips: "造成伤害不低于100点",
            power: 100,
            anger: 20,
            type: 4,
            category: 1,
            accuracy: 95,
            critical: 5,
            times: 1,
            priority: 0,
        }
    ],
    types: [
        {
            id: 3,
            name: "水",
            rates: [
                {
                    type: 4,
                    rate: 200
                }
            ],
        },
        {
            id: 4,
            name: "火",
            rates: [
                {
                    type: 3,
                    rate: 50
                }
            ]
        }
    ],
    buffs: [
        {
            id: 1,
            name: "测试印记",
            tips: "这是一个测试印记",
            count_max: 3,
            round_default: 3,
            endless: 0,
            effects: [
                {
                    hook: "Moving",
                    order: 1400,
                    effect: "0&&realHurt(2,100)",
                }
            ]
        }
    ],
    items: [
        {
            id: 10001,
            name: "测试道具",
            tips: "这是一个测试道具",
            effects: [
                {
                    hook: "RoundStart",
                    order: 1400,
                    effect: "0&&realHurt(2,100)",
                }
            ]
        }
    ],
    weathers: [
        {
            id: 1,
            name: "晴天",
            tips: "这是晴天",
            effects: [
                {
                    hook: "SkillPower",
                    order: 1400,
                    effect: "(\
          _if(thisSkillType()==3,attrMul(2)),\
          _if(thisSkillType()==4,attrDiv(2)),\
          )",
                }
            ]
        }
    ],
};