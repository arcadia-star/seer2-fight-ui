import {useEffect, useRef, useState} from "react";
import {FlashEvent} from "@/components/ruffle-player.tsx";
import {Arena, ArenaEl} from "@/components/arena.tsx";
import {PetStat} from "@/components/stat.tsx";
import {Toaster} from "@/components/ui/sonner.tsx";
import {toast} from "sonner"

function App() {
    const [frame, setFrame] = useState(() => {
        const pet: PetStat = {
            avatar: "/svg/demo-pet-avatar.svg",
            name: "不大长的名字",
            hp: 500,
            hpMax: 600,
            anger: 80,
            angerMax: 100,
            level: 100,
            buffs: [{}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}].map(() => ({
                icon: "/svg/demo-fight-buff.svg",
                tips: "demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff demo fight buff"
            })),
            petTypeIcon: "/svg/demo-pet-type.svg",
            petTypeTips: "草",
            petEmblemIcon: "/svg/demo-pet-emblem.svg",
            petEmblemTips: "pet emblem",
            petEmblem2Icon: "/svg/demo-pet-emblem.svg",
            petEmblem2Tips: "pet emblem",
            petFeatureIcon: "/svg/demo-pet-feature.svg",
            petFeatureTips: "pet feature",
        };
        const round = {
            round: 100,
            weatherIcon: "/svg/demo-fight-weather.svg",
            weatherTips: "fight weather",
        };
        const skills = [
            {
                name: "俩字",
                category: "物理",
                onClick: () => playRandom(),
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
                onClick: () => playRandom(),
                tips: "乐声清脆动听得就像昆仑山美玉击碎，凤凰鸣叫；时而像芙蓉在露水中饮泣，时而像香兰开怀欢笑。"
            }, {
                name: "四字弟弟",
                category: "属性",
                onClick: () => playRandom(),
                tips: "昆山玉碎凤凰叫：昆仑玉碎，形容乐音清脆。昆山：即昆仑山。凤凰叫：形容乐音和缓。芙蓉泣露、香兰笑：形容乐声时而低回，时而轻快。"
            }, {
                name: "五个字怎样",
                category: "必杀",
                onClick: () => playRandom(),
                tips: "“昆山”句是以声写声，着重表现乐声的起伏多变；“芙蓉”句则是以形写声，刻意渲染乐声的优美动听，用比喻的手法描绘了李凭弹奏箜篌的音乐特色。"
            }, {
                name: "最多有六个字",
                category: "合体",
                onClick: () => playRandom(),
                tips: "昆山玉碎凤凰叫，芙蓉泣露香兰笑。"
            }
        ]
            .map(e => Object.assign({
                name: "最多有六个字",
                tips: "描述可以很长很长",
                category: "俩字",
                power: 100,
                anger: 100,
                typeIcon: "/svg/demo-pet-type.svg",
                onClick: () => toast("click skill")
            }, e))
        return {
            background: "/svg/fight-bg.svg",
            left: pet,
            right: pet,
            round,
            logs: `Jokester began sneaking into the castle in the middle of the night and leaving
                        jokes all over the place: under the king's pillow, in his soup, even in the
                        royal toilet. The king was furious, but he couldn't seem to stop Jokester. And
                        then, one day, the people of the kingdom discovered that the jokes left by
                        Jokester were so funny that they couldn't help but laugh. And once they
                        started laughing, they couldn't stop.`,
            skills,
            pets: [1, 2, 3, 4, 5, 6, 7].map((e, idx) => ({
                icon: "/svg/demo-pet-avatar.svg",
                onClick: () => toast("click pet:" + e + " " + idx)
            })),
            capsules: [1, 2, 3, 4, 5, 6, 7].map((e, idx) => ({
                icon: "/svg/demo-item-capsule.svg",
                count: 100,
                onClick: () => toast("click capsule:" + e + " " + idx)
            })),
            items: [1, 2, 3, 4, 5, 6, 7].map((e, idx) => ({
                icon: "/svg/demo-item-hp.svg",
                count: 100,
                onClick: () => toast("click item:" + e + " " + idx)
            })),
            onFlashEvent: (e: FlashEvent) => console.log(e),
            onClickEscape: () => toast("click escape"),
        }
    });
    const [url, setUrl] = useState("/swf/FightPlayer.swf")
    useEffect(() => {
        const interval = setInterval(() => {
            setFrame(frame => {
                return {...frame, left: {...frame.left, hp: frame.left.hp - 100}};
            })
        }, 3000);
        const interval2 = setInterval(() => {
            setFrame(frame => {
                arrayRandom(frame.skills)?.onClick();
                return frame;
            });
        }, 3000);
        const interval3 = setInterval(() => {
            const r1 = random(1000);
            const r2 = random(1000);
            setUrl(`/swf/FightPlayer.swf?url=http://seer2.61.com/res/pet/fight/${r1}.swf&url2=http://seer2.61.com/res/pet/fight/${r2}.swf`);
        }, 10 * 1000);
        return () => {
            clearInterval(interval);
            clearInterval(interval2);
            clearInterval(interval3);
        };
    }, [])


    const random = (value: number) => {
        return Math.floor((Math.random() * value));
    }
    const arrayRandom = function <T>(array: T[]) {
        return array[random(array.length)];
    }
    const playRandom = () => {
        playFight(
            arrayRandom([1, 2]),
            arrayRandom(['物理攻击', '属性攻击', '特殊攻击', '必杀', '合体攻击']),
            arrayRandom(['被打', '被暴击', '闪避', '']),
            arrayRandom(['待机', '濒死'])
        );
    };

    const arenaRef = useRef<ArenaEl>(null);
    const playFight = (side: number, ...args: string[]) => arenaRef.current?.playFight(side, ...args);
    return <div>
        <Arena ref={arenaRef} url={url} frame={frame}/><Toaster/>
    </div>
}

export default App