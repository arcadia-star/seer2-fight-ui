import {cn} from "@/lib/utils.ts";
import {Tips} from "@/components/tips.tsx";

interface BuffProps {
    icon: string,
    tips: string,
}

export function Buff({
                         icon,
                         tips
                     }: BuffProps) {
    return <Tips tips={tips}>
        <div className="h-10 w-10 m-[1px] cursor-pointer">
            <img src={icon} alt="buff"
                 className={cn("h-full object-cover", "")}/>
        </div>
    </Tips>
}

export interface PetStat {
    avatar: string,
    name: string,
    hp: number,
    hpMax: number,
    anger: number,
    angerMax: number,
    level: number,
    buffs: BuffProps[],
    petTypeIcon: string,
    petTypeTips: string,
    petEmblemIcon: string,
    petEmblemTips: string,
    petEmblem2Icon: string,
    petEmblem2Tips: string,
    petFeatureIcon: string,
    petFeatureTips: string,
}

interface StatProps extends PetStat {
    right: boolean
}

export function Stat({
                         right,
                         avatar,
                         name,
                         hp,
                         hpMax,
                         anger,
                         angerMax,
                         level,
                         buffs,
                         petTypeIcon,
                         petTypeTips,
                         petEmblemIcon,
                         petEmblemTips,
                         petEmblem2Icon,
                         petEmblem2Tips,
                         petFeatureIcon,
                         petFeatureTips,
                     }: StatProps) {
    const xReverse = right ? 'scale-x-[-1]' : '';
    return <div className={cn("flex items-start", xReverse)}>
        <div className="flex flex-col items-center z-1">
            <div className="w-20 h-20 rounded-lg bg-black">
                <img src={avatar} alt="avatar" className="w-full h-full object-cover"/>
            </div>
            <div
                className="w-24 h-5 rounded-lg bg-black mt-1 flex items-center justify-center text-cyan-400 text-xs leading-none">
                <span className={cn("truncate", xReverse)}>{name}</span>
            </div>
        </div>
        <div className="flex flex-col pb-4 -ml-4">
            <div className="bg-black pl-2 pb-1 pr-1 rounded-r">
                <div className="flex items-center gap-1">
                    <div className={cn("text-green-600 w-5 text-right font-mono", xReverse)}>HP</div>
                    <div className="w-102 h-5 bg-gray-700/80 relative">
                        <div
                            className={cn("absolute w-full h-full text-center leading-5 font-mono", xReverse)}>{hp}/{hpMax}
                        </div>
                        <div
                            className="h-full bg-gradient-to-r from-lime-500 to-green-600"
                            style={{"width": Math.floor(100 * hp / hpMax) + "%"}}>
                        </div>
                    </div>
                </div>
                <div className="flex items-center gap-1">
                    <div className={cn("text-orange-600 w-5 text-right font-mono", xReverse)}>MP</div>
                    <div className="w-102 h-5 bg-gray-700/80 relative">
                        <div
                            className={cn("absolute w-full h-full text-center leading-5 font-mono", xReverse)}>{anger}/{angerMax}
                        </div>
                        <div
                            className="h-full bg-gradient-to-r from-red-500 to-red-600"
                            style={{"width": Math.floor(100 * anger / angerMax) + "%"}}>
                        </div>
                    </div>
                </div>
            </div>
            <div className="flex">
                <div className="flex items-center gap-1 bg-black px-2 rounded-br-lg">
                    <div className={cn("text-white-500 leading-5 font-mono", xReverse)}>LV:{level}</div>
                    <Tips tips={petTypeTips}>
                        <div className="h-4 pl-1">
                            <img src={petTypeIcon} alt="type"
                                 className={cn("w-full h-full object-cover", xReverse)}/>
                        </div>
                    </Tips>
                    <Tips tips={petEmblemTips}>
                        <div className="h-4 pl-1">
                            <img src={petEmblemIcon} alt="emblem"
                                 className={cn("w-full h-full object-cover", xReverse)}/>
                        </div>
                    </Tips>
                    <Tips tips={petEmblem2Tips}>
                        <div className="h-4 pl-1">
                            <img src={petEmblem2Icon} alt="emblem2"
                                 className={cn("w-full h-full object-cover", xReverse)}/>
                        </div>
                    </Tips>
                    <Tips tips={petFeatureTips}>
                        <div className="h-4 pl-1">
                            <img src={petFeatureIcon} alt="feature"
                                 className={cn("w-full h-full object-cover", xReverse)}/>
                        </div>
                    </Tips>
                </div>
            </div>
            <div className="flex flex-wrap w-106 ml-5 mt-2">{
                buffs?.map((buff, idx) => <Buff key={idx} {...buff}/>)
            }</div>
        </div>
    </div>
}