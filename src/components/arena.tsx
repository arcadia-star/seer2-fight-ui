import {Round, Stat} from "@/components/arena-stat";
import {ScrollArea} from "@/components/ui/scroll-area";
import {Escape, Item, Pet, Skill} from "@/components/arena-button";
import {
    ChangeFrame,
    Frame,
    FrameFighter,
    FrameType,
    IdleFrame,
    MoveFrame,
    MoveFrameDamage,
    MoveSkillCategory
} from "@/frame";
import {Ref, useEffect, useRef, useState} from "react";
import {FlashEvent, RufflePlayer, RufflePlayerEl} from "@/components/ruffle-player";
import {toast} from "sonner";
import {Damage} from "@/components/arena-damage.tsx";
import {gsap} from "gsap";
import {build4PlayFight, build4UpdatePet, FlashEventType} from "@/frame-flash.ts";

type CommandHandler = (data: { skill?: number, pet?: number, item?: number }) => void;

enum FightTab {
    Catch,
    Pet,
    Skill,
    Item,
    Escape
}

function FightButton({text, onClick}: { text: string, onClick: () => void }) {
    return <div
        className="bg-black text-center font-mono font-bold text-cyan-400 border border-cyan-400/30 hover:border-cyan-400 hover:shadow-lg hover:shadow-cyan-400/50 hover:scale-105 transition-all duration-200 cursor-pointer rounded-sm py-1 tracking-widest"
        onClick={() => onClick()}
    >{text}</div>
}

function FightButtons({update}: { update: (tab: FightTab) => void }) {
    return <div className="flex flex-col w-[170px] gap-1">
        {/* 第一行：精灵和捕捉，各占50% */}
        <div className="flex gap-1">
            <div className="w-1/2">
                <FightButton text={"精灵"} onClick={() => update(FightTab.Pet)}/>
            </div>
            <div className="w-1/2">
                <FightButton text={"捕捉"} onClick={() => update(FightTab.Catch)}/>
            </div>
        </div>

        {/* 第二行：战斗，占满宽度 */}
        <div className="w-full relative group">
            <FightButton text={"战斗"} onClick={() => update(FightTab.Skill)}/>
            <div className="absolute inset-0 flex items-center justify-center pointer-events-none">
                <div
                    className="w-16 h-16 border-2 border-cyan-400/30 rounded-full group-hover:w-20 group-hover:h-20 group-hover:border-cyan-400 transition-all duration-200"></div>
                <div
                    className="absolute w-20 h-20 border-2 border-cyan-400/30 rounded-full group-hover:w-24 group-hover:h-24 group-hover:border-cyan-400 transition-all duration-200"></div>
            </div>
        </div>

        {/* 第三行：道具和逃跑，各占50% */}
        <div className="flex gap-1">
            <div className="w-1/2">
                <FightButton text={"道具"} onClick={() => update(FightTab.Item)}/>
            </div>
            <div className="w-1/2">
                <FightButton text={"逃跑"} onClick={() => update(FightTab.Escape)}/>
            </div>
        </div>
    </div>
}

type ArenaBottomProps = {
    fighter: FrameFighter,
    onClick?: CommandHandler,
    disabled?: boolean,
}

function ArenaBottom({fighter, onClick, disabled}: ArenaBottomProps) {
    const [fightBtnTab, setFightBtnTab] = useState(FightTab.Skill);
    const containerRef = useRef<HTMLDivElement>(null);

    useEffect(() => {
        if (!containerRef.current) return;

        // 获取所有子元素
        const children = containerRef.current.children;

        // 设置容器和子元素初始状态
        gsap.set(containerRef.current, {
            opacity: 1
        });

        gsap.set(children, {
            opacity: 0,
            x: 60,
            scale: 0.8
        });

        // 创建错开动画
        gsap.to(children, {
            opacity: 1,
            x: 0,
            scale: 1,
            duration: 0.3,
            ease: "back.out(1.7)",
            stagger: 0.05
        });
    }, [fightBtnTab]);

    return <div className="absolute bottom-0 w-full">
        <div className="bg-black/80 p-4 flex justify-between items-center relative">
            <ScrollArea className="bg-black/50 border-2 rounded-sm border-[#00e9f79c] h-[110px] w-[250px]">
                <div className="text-white">logs logs logs logs logs logs logs logs logs logs logs logs
                </div>
            </ScrollArea>
            <ScrollArea className="h-[90px] w-[880px]">
                <div ref={containerRef} className="flex gap-3 flex-wrap mx-5 mt-2">
                    {
                        fightBtnTab === FightTab.Skill && fighter.skills.map((skill, idx) =>
                            <Skill key={idx} data={skill} disabled={disabled}
                                   onClick={() => {
                                       setFightBtnTab(FightTab.Skill);
                                       onClick?.({skill: idx + 1});
                                   }}/>)
                        || fightBtnTab === FightTab.Pet && fighter.pets.map((pet, idx) =>
                            <Pet key={idx} data={pet} disabled={disabled}
                                 onClick={() => {
                                     setFightBtnTab(FightTab.Skill);
                                     onClick?.({pet: idx + 1});
                                 }}/>)
                        || fightBtnTab === FightTab.Catch && fighter.capsules.map((item, idx) =>
                            <Item key={idx} data={item} disabled={disabled}
                                  onClick={() => toast.success("catch:" + idx) && setFightBtnTab(FightTab.Skill)}/>)
                        || fightBtnTab === FightTab.Item && fighter.items.map((item, idx) =>
                            <Item key={idx} data={item} disabled={disabled}
                                  onClick={() => toast.success("item:" + idx) && setFightBtnTab(FightTab.Skill)}/>)
                        || fightBtnTab === FightTab.Escape && <Escape onClick={() => 0}/>
                    }
                </div>
            </ScrollArea>
            <FightButtons update={setFightBtnTab}/>
        </div>
    </div>
}

type ArenaMainProps = {
    frame: IdleFrame,
    onClick?: CommandHandler,
    disabled?: boolean,
}

function ArenaMain({frame, onClick, disabled}: ArenaMainProps) {
    return <div className="flex flex-col">
        {/* 背景图片 */}
        <div className="absolute inset-0 -z-10">
            <img src={frame.common.background} alt="background" className="w-full h-full object-cover"/>
        </div>

        {/* 顶部状态栏 */}
        <div className="flex justify-between items-start text-white drop-shadow-lg relative mt-2">
            {/* 玩家状态 */}
            <Stat right={false} data={frame.left.master}/>

            {/* 回合数 */}
            <Round data={frame.common}/>

            {/* 敌人状态 */}
            <Stat right={true} data={frame.right.master}/>
        </div>

        {/* 底部技能栏 */}
        <ArenaBottom fighter={frame?.left} onClick={onClick} disabled={disabled}/>
    </div>
}

type ArenaProps = {
    arenaRef: Ref<HTMLDivElement>,
    frame?: Frame,
    onFrameEnd?: () => void,
    onClick?: CommandHandler,
}

function ArenaDamage({damage, right}: { damage: MoveFrameDamage, right: boolean }) {
    // 判断显示位置：闪避或小于10000时偏移，否则居中
    const shouldOffset = damage.hit <= 0 || damage.total < 10000;

    if (shouldOffset) {
        // 根据攻击方向偏移显示
        // right=true 表示右边角色攻击，伤害显示在左边（受击方）
        // right=false 表示左边角色攻击，伤害显示在右边（受击方）
        const offsetClass = right ? "mr-24" : "ml-24";
        return <div className={`absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 ${offsetClass}`}>
            <Damage hit={damage.hit} cri={damage.cri} rate={damage.rate} total={damage.total}/>
        </div>
    } else {
        // 居中显示（大数值）
        return <div className="absolute top-1/2 left-0 right-0 transform -translate-y-1/2 flex justify-center px-16">
            <Damage hit={damage.hit} cri={damage.cri} rate={damage.rate} total={damage.total}/>
        </div>
    }
}

export function Arena({arenaRef, frame, onFrameEnd, onClick}: ArenaProps) {
    const [idleFrame, setIdleFrame] = useState<IdleFrame>();
    const [damage, setDamage] = useState<MoveFrameDamage | undefined>()
    const [damageSide, setDamageSide] = useState<number | undefined>()

    const ruffleRef = useRef<RufflePlayerEl>(null);
    const frameVersion = useRef(0);

    useEffect(() => {
        if (!arenaRef || !('current' in arenaRef) || !arenaRef.current) return;

        if (damage) {
            // 用 gsap 创建抖动动画
            const timeline = gsap.timeline();

            timeline
                .to(arenaRef.current, {
                    x: -16,
                    duration: 0.05,
                    ease: "power2.inOut"
                })
                .to(arenaRef.current, {
                    x: 16,
                    duration: 0.05,
                    ease: "power2.inOut"
                })
                .to(arenaRef.current, {
                    x: -12,
                    duration: 0.05,
                    ease: "power2.inOut"
                })
                .to(arenaRef.current, {
                    x: 12,
                    duration: 0.05,
                    ease: "power2.inOut"
                })
                .to(arenaRef.current, {
                    x: -8,
                    duration: 0.05,
                    ease: "power2.inOut"
                })
                .to(arenaRef.current, {
                    x: 8,
                    duration: 0.05,
                    ease: "power2.inOut"
                })
                .to(arenaRef.current, {
                    x: -4,
                    duration: 0.05,
                    ease: "power2.inOut"
                })
                .to(arenaRef.current, {
                    x: 4,
                    duration: 0.05,
                    ease: "power2.inOut"
                })
                .to(arenaRef.current, {
                    x: 0,
                    duration: 0.1,
                    ease: "power2.out"
                });

            return () => {
                timeline.kill();
            };
        }
    }, [damage, arenaRef]);

    useEffect(() => {
        frameVersion.current += 1;
        const version = frameVersion.current;

        function updateFrame(idleFrame: IdleFrame, moveFrameDamage?: MoveFrameDamage, damageSide?: number) {
            setIdleFrame(idleFrame);
            setDamage(moveFrameDamage);
            setDamageSide(damageSide);
        }

        function updatePet(frame: IdleFrame, change: boolean = false) {
            console.log("call updatePet with version:" + version)
            ruffleRef.current?.callFlash("flash_updatePet", build4UpdatePet(frame, change), version);
        }

        function playFight(frame: MoveFrame) {
            console.log("call playFight with version:" + version)
            ruffleRef.current?.callFlash("flash_playFight", build4PlayFight(frame), version);
        }

        function withCallback(player: () => void, handler: (event: FlashEvent) => void) {
            ruffleRef.current?.updateCallback(event => {
                if (event.type === FlashEventType.INIT) {
                    player();
                }
                if (version !== frameVersion.current) {
                    return;
                }
                if (version !== event.version) {
                    return;
                }
                handler(event);
            });
            player();
        }

        if (!frame) {
            return
        }
        if (frame.type === FrameType.Idle) {
            const idleFrame = frame.data as IdleFrame;
            withCallback(() => {
                const frame = idleFrame;
                updateFrame(frame);
                updatePet(frame);
            }, event => {
                if (event.type === FlashEventType.READY) {
                    onFrameEnd?.();
                }
            });
        }
        if (frame.type === FrameType.Move) {
            const moveFrame = frame.data as MoveFrame;
            withCallback(() => {
                const frame = moveFrame.start;
                updateFrame(frame);
                updatePet(frame);
            }, event => {
                if (event.type === FlashEventType.READY) {
                    playFight(moveFrame);
                }
                if (event.type === FlashEventType.HIT) {
                    updateFrame(
                        moveFrame.end,
                        moveFrame.skillCategory === MoveSkillCategory.Typical ? undefined : moveFrame.damage,
                        moveFrame.move
                    );
                }
                if (event.type === FlashEventType.MOVE_END) {
                    onFrameEnd?.();
                }
            });
        }
        if (frame.type === FrameType.Change) {
            const changeFrame = frame.data as ChangeFrame;
            withCallback(() => {
                const frame = changeFrame.start;
                updateFrame(frame);
                updatePet(frame);
            }, e => {
                if (e.type === FlashEventType.READY) {
                    withCallback(() => {
                        const frame = changeFrame.end;
                        updateFrame(frame);
                        updatePet(frame, true);
                    }, e => {
                        if (e.type === FlashEventType.READY) {
                            onFrameEnd?.();
                        }
                    })
                }
            });
        }
    }, [frame, onFrameEnd]);

    return (<div ref={arenaRef} className="w-[1200px] h-[660px] mx-auto my-auto relative">
        {/* 战斗区域 */}
        <div className="absolute w-full h-full flex justify-center items-end pointer-events-none">
            <RufflePlayer ref={ruffleRef} url={"/swf/FightPlayer.swf?silence=true"}/>
        </div>
        {
            damage && <ArenaDamage damage={damage} right={damageSide === 2}/>
        }
        {
            idleFrame && <ArenaMain frame={idleFrame} onClick={onClick} disabled={frame?.type !== FrameType.Idle}/>
        }
    </div>)
}


