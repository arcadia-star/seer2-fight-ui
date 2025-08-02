import {Arena, CommandEvent} from "@/components/arena.tsx";
import {useCallback, useEffect, useRef, useState} from "react";
import {Frame, FrameType, IdleFrame, MoveSkillCategory} from "@/frame.ts";
import {random, randomIdleFrame} from "@/frame-random.ts";

function copy<T>(obj: T): T {
    if (!obj) {
        return obj;
    }
    return JSON.parse(JSON.stringify(obj));
}

export function DemoGamePlayer() {
    const arenaRef = useRef<HTMLDivElement>(null);
    const [frame, setFrame] = useState<Frame>();
    const frameRef = useRef(randomIdleFrame());
    const frameEndRef = useRef<() => void>(null);
    const processing = useRef(false);

    useEffect(() => {
        const frame = frameRef.current;
        frame.common.round = 1;
        frame.left.master.hpMax = frame.left.master.hp = 1000;
        frame.right.master.hpMax = frame.right.master.hp = 1000;
        frame.left.capsules.forEach(e => e.tips = "随机换一个对手");
        setFrame({
            type: FrameType.Idle,
            data: copy(frame),
            logs: [],
            timestamp: Date.now(),
        })
    }, []);

    const onClick = useCallback(async ({skill, pet, capsule}: CommandEvent) => {
        function updateFrame(frame: Frame) {
            return new Promise(resolve => {
                frameEndRef.current = () => {
                    frameEndRef.current = null;
                    return resolve(null);
                };
                setFrame(frame);
            });
        }

        async function nextRound() {
            frame.common.round += 1;
            await updateFrame({
                type: FrameType.Idle,
                data: copy(frame),
                logs: [],
                timestamp: Date.now(),
            });
        }

        async function changePet(start: IdleFrame) {
            await updateFrame({
                type: FrameType.Change,
                data: {
                    start,
                    end: copy(frame),
                },
                logs: [],
                timestamp: Date.now(),
            });
        }

        if (processing.current) {
            return;
        }
        processing.current = true;
        const frame = frameRef.current;
        if (skill) {
            let start = copy(frame);
            const frameSkill = start.left.skills[skill - 1];
            frame.right.master.hp -= 100;
            frame.right.master.anger += 10;
            await updateFrame({
                type: FrameType.Move,
                data: {
                    start,
                    end: copy(frame),
                    move: 1,
                    skillName: frameSkill.name,
                    skillCategory: frameSkill.category as MoveSkillCategory,
                    damage: {
                        hit: 1,
                        cri: 0,
                        rate: 200,
                        total: random(999999999)
                    },
                },
                logs: [],
                timestamp: Date.now(),
            });

            start = copy(frame);
            frame.left.master.hp -= 100;
            frame.left.master.anger += 10;
            await updateFrame({
                type: FrameType.Move,
                data: {
                    start,
                    end: copy(frame),
                    move: 2,
                    skillName: frameSkill.name,
                    skillCategory: frameSkill.category as MoveSkillCategory,
                    damage: {
                        hit: 1,
                        cri: 0,
                        rate: 200,
                        total: random(999999999)
                    },
                },
                logs: [],
                timestamp: Date.now(),
            });

            await nextRound();
        }
        if (pet) {
            let start = copy(frame);
            const randomFrame = randomIdleFrame();
            frame.left.master.name = randomFrame.left.master.name;
            frame.left.master.flash = randomFrame.left.master.flash;
            await changePet(start);

            start = copy(frame);
            frame.left.master.hp -= 100;
            frame.left.master.anger += 10;
            await updateFrame({
                type: FrameType.Move,
                data: {
                    start,
                    end: copy(frame),
                    move: 2,
                    skillName: "随机",
                    skillCategory: MoveSkillCategory.Physical,
                    damage: {
                        hit: 1,
                        cri: 0,
                        rate: 200,
                        total: random(999999999)
                    },
                },
                logs: [],
                timestamp: Date.now(),
            });

            await nextRound();
        }
        if (capsule) {
            const start = copy(frame);
            const randomFrame = randomIdleFrame();
            frame.right.master.name = randomFrame.right.master.name;
            frame.right.master.flash = randomFrame.right.master.flash;
            await changePet(start);

            await nextRound();
        }
        processing.current = false;
    }, []);

    return <div>
        <Arena arenaRef={arenaRef}
               frame={frame}
               onFrameEnd={() => frameEndRef.current?.()}
               onClick={onClick}
        />
    </div>
}