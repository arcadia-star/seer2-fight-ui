import {cn} from "@/lib/utils";
import {FrameBuff, FrameCommon, FramePet} from "@/frame";
import {Tooltip, TooltipContent, TooltipProvider, TooltipTrigger} from "@/components/ui/tooltip";
import React from "react";
import RoundBarBg from "@/assets/round-bar-bg.svg"

type TipsProps = {
    children?: React.ReactNode; tips: string
}

function Tips({children, tips}: TipsProps) {
    return <TooltipProvider>
        <Tooltip>
            <TooltipTrigger asChild>
                {children}
            </TooltipTrigger>
            <TooltipContent side="bottom">
                <div className="max-w-100">{tips}</div>
            </TooltipContent>
        </Tooltip>
    </TooltipProvider>
}

type RoundProps = {
    data: FrameCommon,
}

export function Round({data}: RoundProps) {
    return <div className="flex flex-col items-center">
        <img src={RoundBarBg} alt="" className="absolute -mt-2"/>
        <div className="text-xl text-yellow-300 font-semibold italic pointer-events-none mt-1 z-1">回{data.round}合
        </div>
        <Tips tips={data.weather.tips}>
            <div>
                <img src={data.weather.icon} alt="weather"
                     className={cn("h-10 object-cover mt-2", "")}/>
            </div>
        </Tips>
    </div>
}

type BuffProps = {
    data: FrameBuff
}

export function Buff({data}: BuffProps) {
    return <Tips tips={data.tips}>
        <div className="h-10 w-10 m-[1px] cursor-pointer">
            <img src={data.icon} alt="buff"
                 className={cn("h-full object-cover", "")}/>
        </div>
    </Tips>
}

type StatProps = {
    data: FramePet
    right: boolean
}

export function Stat({data, right,}: StatProps) {
    const xReverse = right ? 'scale-x-[-1]' : '';
    return <div className={cn("flex items-start", xReverse)}>
        <div className="flex flex-col items-center z-1">
            <div className="w-20 h-20 rounded-lg bg-black border-2 border-white">
                <img src={data.avatar} alt="avatar" className="w-full h-full object-cover rounded"/>
            </div>
            <div
                className="w-24 h-5 rounded-lg bg-black mt-1 flex items-center justify-center text-cyan-400 text-xs leading-none">
                <span className={cn("truncate", xReverse)}>{data.name}</span>
            </div>
        </div>
        <div className="flex flex-col -ml-5">
            <div className="bg-black pb-1 pl-4 rounded-r w-92">
                <div className="flex items-center gap-1">
                    <div className={cn("text-green-600 w-6 text-center font-mono", xReverse)}>HP</div>
                    <div className="w-80 h-5 bg-gray-700/80 relative">
                        <div
                            className={cn("absolute w-full h-full text-center leading-5 font-mono", xReverse)}>{data.hp}/{data.hpMax}
                        </div>
                        <div
                            className="h-full bg-gradient-to-r from-lime-500 to-green-600 transition-all duration-800"
                            style={{"width": Math.max(Math.min(Math.floor(100 * data.hp / data.hpMax), 100), 0) + "%"}}>
                        </div>
                    </div>
                </div>
                <div className="flex items-center gap-1">
                    <div className={cn("text-orange-600 w-6 text-center font-mono", xReverse)}>MP</div>
                    <div className="w-80 h-5 bg-gray-700/80 relative">
                        <div
                            className={cn("absolute w-full h-full text-center leading-5 font-mono", xReverse)}>{data.anger}/{data.angerMax}
                        </div>
                        <div
                            className="h-full bg-gradient-to-r from-red-500 to-red-600 transition-all duration-800"
                            style={{"width": Math.max(Math.min(Math.floor(100 * data.anger / data.angerMax), 100), 0) + "%"}}>
                        </div>
                    </div>
                </div>
            </div>
            <div className="flex">
                <div className="flex items-center gap-1 bg-black pl-4 pr-2 rounded-br-lg">
                    <div className={cn("text-white-500 leading-5 font-mono", xReverse)}>LV:{data.level}</div>
                    <Tips tips={data.petType.tips}>
                        <div className="h-4 pl-1">
                            <img src={data.petType.icon} alt="type"
                                 className={cn("w-full h-full object-cover", xReverse)}/>
                        </div>
                    </Tips>
                    <Tips tips={data.petEmblem.tips}>
                        <div className="h-4 pl-1">
                            <img src={data.petEmblem.icon} alt="emblem"
                                 className={cn("w-full h-full object-cover", xReverse)}/>
                        </div>
                    </Tips>
                    <Tips tips={data.petEmblem2.tips}>
                        <div className="h-4 pl-1">
                            <img src={data.petEmblem2.icon} alt="emblem2"
                                 className={cn("w-full h-full object-cover", xReverse)}/>
                        </div>
                    </Tips>
                    <Tips tips={data.petFeature.tips}>
                        <div className="h-4 pl-1">
                            <img src={data.petFeature.icon} alt="feature"
                                 className={cn("w-full h-full object-cover", xReverse)}/>
                        </div>
                    </Tips>
                </div>
            </div>
            <div className="flex flex-wrap w-106 ml-5 mt-2">{
                data.buffs?.map((buff, idx) => <Buff key={idx} data={buff}/>)
            }</div>
        </div>
    </div>
}