import {RufflePlayer, RufflePlayerEl} from "@/components/ruffle-player.tsx";
import {RefObject} from "react";
import {Arena, Frames} from "@/types.ts";
import {Buffer} from "buffer";

export interface DemoPlayerProps {
    ruffleRef: RefObject<RufflePlayerEl | null>
    frames: Frames;
    idx: number;
}

export function DemoPlayer({ruffleRef, frames, idx}: DemoPlayerProps) {
    const arena = (frames.frames?.[idx] as { data: Arena; } | undefined)?.data;
    if (!arena) {
        return <div>非数据帧，无法演示</div>
    }
    const demoFrames = {...frames, frames: [{data: arena}]};
    return <div className="w-[1200px] h-[660px] relative">
        <RufflePlayer ref={ruffleRef}
                      url={"demo/DemoPlayer.swf?playUrl=data:text/plain;base64," + encodeURIComponent(Buffer.from((JSON.stringify(demoFrames))).toString('base64')) + "&"}/>
    </div>
}