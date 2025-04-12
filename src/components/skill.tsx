import {cn} from "@/lib/utils.ts";
import {Tooltip, TooltipContent, TooltipProvider, TooltipTrigger} from "@/components/ui/tooltip.tsx";

import BtnSkillBg from "@/assets/svg/skill-btn.svg";

export interface SkillProps {
    name: string,
    tips: string,
    category: string,
    power: number,
    anger: number,
    typeIcon: string,
    onClick: () => void,
}

export function Skill({
                          name,
                          tips,
                          category,
                          power,
                          anger,
                          typeIcon,
                          onClick
                      }: SkillProps) {
    const textColor = "text-yellow-300";
    return <TooltipProvider>
        <Tooltip>
            <TooltipTrigger asChild>
                <div className="relative h-[85px] w-[158px] group">
                    <div onClick={onClick}
                         className={cn("absolute w-full h-full z-1 cursor-pointer trigger-area")}></div>
                    <img src={typeIcon} alt="pet-type" className={cn("absolute w-2/10 left-1/10 top-5/20")}/>
                    <img src={BtnSkillBg} alt="skill-bg" className={cn("w-full h-full")}/>
                    <div
                        className={cn("text-left font-mono truncate absolute left-8/20 top-2/20", textColor)}>{name}</div>
                    <div
                        className={cn("text-left font-mono truncate absolute left-8/20 top-8/20", textColor)}>威力 {power}</div>
                    <div
                        className={cn("text-left font-mono truncate absolute left-8/20 top-14/20", textColor)}>怒气 {anger}</div>
                    <div
                        className={cn("text-left font-mono truncate absolute left-2/20 top-27/40", textColor)}>{category}</div>
                </div>
            </TooltipTrigger>
            <TooltipContent side="bottom" className="opacity-90">
                <div className="w-50 h-50">{tips}</div>
            </TooltipContent>
        </Tooltip>
    </TooltipProvider>
}