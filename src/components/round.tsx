import {cn} from "@/lib/utils.ts";
import {Tips} from "@/components/tips";

export interface RoundProps {
    round: number,
    weatherIcon: string
    weatherTips: string,
}

export function Round({round, weatherIcon, weatherTips}: RoundProps) {
    return <div className="flex flex-col items-center">
        <div className="text-xl text-yellow-300 font-semibold">回{round}合</div>
        <Tips tips={weatherTips}>
            <div>
                <img src={weatherIcon} alt="weather"
                     className={cn("h-10 object-cover", "")}/>
            </div>
        </Tips>
    </div>
}