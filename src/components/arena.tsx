import {FlashEvent, RufflePlayer, RufflePlayerEl} from "@/components/ruffle-player.tsx";
import {Ref, useImperativeHandle, useRef, useState} from "react";
import {PetStat, Stat} from "@/components/stat.tsx";
import {Round, RoundProps} from "@/components/round.tsx";
import {cn} from "@/lib/utils.ts";
import {ScrollArea} from "@/components/ui/scroll-area.tsx";
import {Skill, SkillProps} from "@/components/skill.tsx";
import {Button} from "@/components/ui/button.tsx";

import BtnPet from "@/assets/svg/fight-btn-pet.svg";
import BtnCatch from "@/assets/svg/fight-btn-catch.svg";
import BtnItem from "@/assets/svg/fight-btn-item.svg";
import BtnEscape from "@/assets/svg/fight-btn-escape.svg";
import BtnSkillLine from "@/assets/svg/fight-btn-skill-line.svg";
import BtnSkillBg0 from "@/assets/svg/fight-btn-skill-bg0.svg";
import BtnSkillBg from "@/assets/svg/fight-btn-skill-bg.svg";
import BtnSkillHan from "@/assets/svg/fight-btn-skill-han.svg";

enum FightTab {
    Catch,
    Pet,
    Skill,
    Item,
    Escape
}

function FightButtons({update}: { update: (tab: FightTab) => void }) {
    const btn = "w-full h-full object-cover cursor-pointer";
    const center = "left-1/2 top-1/2 transform -translate-x-1/2 -translate-y-1/2";
    return <div className="flex-row min-h-[110px] min-w-[176px]">
        <div className="flex">
            <img src={BtnPet} alt="btn-pet" className={cn(btn, "mr-1")}
                 onClick={() => update(FightTab.Pet)}/>
            <img src={BtnCatch} alt="btn-catch" className={btn}
                 onClick={() => update(FightTab.Catch)}/>
        </div>
        <div className="my-1 cursor-pointer relative" onClick={() => update(FightTab.Skill)}>
            <img src={BtnSkillLine} alt="btn-skill"
                 className={cn(center, "absolute rotate-90")}/>
            <img src={BtnSkillLine} alt="btn-skill"
                 className={cn(center, "absolute")}/>
            <img src={BtnSkillBg0} alt="btn-skill"
                 className="absolute"/>
            <img src={BtnSkillHan} alt="btn-skill"
                 className={cn(center, "absolute")}/>
            <img src={BtnSkillBg} alt="btn-skill"
                 className="w-full h-full object-cover"/>
        </div>
        <div className="flex">
            <img src={BtnItem} alt="btn-item" className={cn(btn, "mr-1")}
                 onClick={() => update(FightTab.Item)}/>
            <img src={BtnEscape} alt="btn-escape" className={btn}
                 onClick={() => update(FightTab.Escape)}/>
        </div>
    </div>
}

interface PetProps {
    icon: string,
    onClick: () => void,
}

function Pet({icon, onClick}: PetProps) {
    return <img className="h-[90px] border rounded-lg" src={icon} alt="pet" onClick={() => onClick()}/>
}

interface ItemProps {
    icon: string,
    count: number,
    onClick: () => void,
}

function Item({icon, count, onClick}: ItemProps) {
    return <div className="relative">
        <p className="absolute right-0 bottom-0 text-white">{count}</p>
        <img className="h-[90px] border rounded-lg cursor-pointer" src={icon} alt="item" onClick={() => onClick()}/>
    </div>;
}

export interface ArenaEl {
    playFight: (side: number, ...args: string[]) => void
}

export interface ArenaProps {
    ref: Ref<ArenaEl>,
    url: string,
    frame: {
        background: string,
        left: PetStat,
        right: PetStat,
        round: RoundProps,
        logs: string,
        skills: SkillProps[],
        pets: PetProps[],
        capsules: ItemProps[],
        items: ItemProps[],
        onFlashEvent: (event: FlashEvent) => void,
        onClickEscape: () => void,
    },
}

export function Arena({ref, frame, url}: ArenaProps) {
    const ruffleRef = useRef<RufflePlayerEl>(null);
    const playFight = (side: number, ...args: string[]) => ruffleRef.current?.callFlash('flash_playFight', side, ...args);

    useImperativeHandle(ref, () => ({playFight}));

    const [fightTab, setFightTab] = useState(FightTab.Skill);

    return (<div className="h-screen w-screen flex flex-col relative">
        {/* 背景图片 */}
        <div className="absolute inset-0 -z-10">
            <img src={frame.background} alt="background" className="w-full h-full object-cover"/>
        </div>

        {/* 顶部状态栏 */}
        <div className="flex justify-between items-start text-white drop-shadow-lg relative z-10 mt-2">
            {/* 玩家状态 */}
            <Stat right={false} {...frame.left}/>

            {/* 回合数 */}
            <Round {...frame.round}/>

            {/* 敌人状态 */}
            <Stat right={true} {...frame.right}/>
        </div>

        {/* 战斗区域 */}
        <div className="absolute h-screen w-screen flex justify-center items-end">
            <RufflePlayer ref={ruffleRef} url={url} onFlashEvent={frame.onFlashEvent}/>
        </div>

        {/* 底部技能栏 */}
        <div className="absolute bottom-0 w-full">
            <div className="bg-black/80 p-4 flex justify-between items-center relative z-10">
                <ScrollArea className="bg-black/50 border-2 rounded-sm border-[#00e9f79c] h-[110px] w-[250px]">
                    <div className="text-white">{frame.logs}</div>
                </ScrollArea>
                <ScrollArea className="h-[90px] w-[880px]">
                    <div className="flex gap-4 flex-wrap mr-1">
                        {
                            fightTab === FightTab.Skill && frame.skills.map((skill, idx) =>
                                <Skill key={idx} {...skill}/>)
                            || fightTab === FightTab.Pet && frame.pets.map((pet, idx) =>
                                <Pet key={idx} {...pet}/>)
                            || fightTab === FightTab.Catch && frame.capsules.map((item, idx) =>
                                <Item key={idx} {...item}/>)
                            || fightTab === FightTab.Item && frame.items.map((item, idx) =>
                                <Item key={idx} {...item}/>)
                            || fightTab === FightTab.Escape && <div>
                            <Button className="cursor-pointer" onClick={() => frame.onClickEscape()}>confirm</Button>
                            <Button className="cursor-pointer" onClick={() => setFightTab(FightTab.Skill)}>cancel</Button>
                          </div>
                        }
                    </div>
                </ScrollArea>
                <FightButtons update={setFightTab}/>
            </div>
        </div>
    </div>)
}



