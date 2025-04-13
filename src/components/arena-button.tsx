import {cn} from "@/lib/utils";
import {Tooltip, TooltipContent, TooltipProvider, TooltipTrigger} from "@/components/ui/tooltip";
import {FrameItem, FramePet, FrameSkill} from "@/frame";

type SkillProps = {
    data: FrameSkill,
    onClick: () => void,
    disabled?: boolean,
}

export function Skill({data, onClick, disabled}: SkillProps) {
    const text = "text-yellow-300 font-mono";
    return <TooltipProvider>
        <Tooltip>
            <TooltipTrigger asChild>
                <div onClick={() => !disabled && onClick()}
                     className={
                         cn(
                             "bg-black flex border border-cyan-400/30 w-[140px] h-[80px] py-2 hover:border-cyan-400 hover:shadow-lg hover:shadow-cyan-400/50 hover:scale-105 transition-all duration-200 rounded-sm",
                             disabled ? "opacity-50 cursor-not-allowed" : "cursor-pointer"
                         )
                     }>
                    <div className="flex-row w-[37px] ml-2">
                        <div className="-ml-2 h-2/3 flex items-center justify-center overflow-hidden">
                            <div
                                className="w-10 h-10 border-1 border-gray-600 rounded-full flex items-center justify-center">
                                <img src={data.type.icon} alt={data.type.tips}
                                     className="max-w-9/10 max-h-9/10 object-cover"/>
                            </div>
                        </div>
                        <div className={cn(text, "h-1/3 flex items-center")}>{data.category}</div>
                    </div>
                    <div className="flex flex-col">
                        <div className={cn(text, "h-1/3 flex items-center")}>{data.name}</div>
                        <div
                            className={cn(text, "h-1/3 flex items-center border-t border-b border-cyan-400/30 bg-gradient-to-r from-transparent via-cyan-400/10 to-transparent")}>威力 {data.power}</div>
                        <div className={cn(text, "h-1/3 flex items-center")}>怒气 {data.anger}</div>
                    </div>
                </div>
            </TooltipTrigger>
            <TooltipContent side="top" className="opacity-90">
                <div className="w-50 h-50">{data.tips}</div>
            </TooltipContent>
        </Tooltip>
    </TooltipProvider>
}

type PetProps = {
    data: FramePet,
    onClick: () => void,
    disabled?: boolean,
}

export function Pet({data, onClick, disabled}: PetProps) {
    return <div className="flex flex-col">
        <div onClick={() => !disabled && onClick()}
             className={
                 cn(
                     "relative bg-black border border-cyan-400/30 rounded-sm hover:border-cyan-400 hover:shadow-lg hover:shadow-cyan-400/50 hover:scale-105 transition-all duration-200 p-1",
                     disabled ? "opacity-50 cursor-not-allowed" : "cursor-pointer"
                 )
             }>
            <img className="h-[72px] w-full object-cover rounded" src={data.avatar} alt="pet"/>
            <img className="max-h-6 max-w-6 absolute right-0 top-0" src={data.petType.icon} alt={data.petType.tips}/>
            <div className="absolute bottom-0 text-[9px] bg-black/60 px-1 rounded">
                <div className="text-white">LV:{data.level} {data.hp}/{data.hpMax}</div>
                <div className="text-white">{data.name}</div>
            </div>
        </div>
    </div>
}

type ItemProps = {
    data: FrameItem,
    onClick: () => void,
    disabled?: boolean,
}

export function Item({data, onClick, disabled}: ItemProps) {
    return <TooltipProvider>
        <Tooltip>
            <TooltipTrigger asChild>
                <div
                    className={
                        cn(
                            "relative bg-black border border-cyan-400/30 rounded-sm hover:border-cyan-400 hover:shadow-lg hover:shadow-cyan-400/50 hover:scale-105 transition-all duration-200 p-1",
                            disabled ? "opacity-50 cursor-not-allowed" : "cursor-pointer"
                        )
                    }>
                    <img className="h-[70px] w-full object-cover rounded" src={data.icon} alt="item"
                         onClick={() => !disabled && onClick()}/>
                    <p className="absolute right-1 bottom-1 text-white text-xs font-bold">{data.count}</p>
                </div>
            </TooltipTrigger>
            <TooltipContent side="top" className="opacity-90">
                <div className="w-50 h-20">{data.tips}</div>
            </TooltipContent>
        </Tooltip>
    </TooltipProvider>
}

type EscapeProps = {
    onClick: () => void,
}

export function Escape({onClick}: EscapeProps) {
    return <div onClick={() => onClick()}>escape</div>
}