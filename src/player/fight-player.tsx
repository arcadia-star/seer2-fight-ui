import {RufflePlayer, RufflePlayerEl} from "@/components/ruffle-player.tsx";
import {RefObject, useEffect, useRef} from "react";
import type {Frames} from "@/types.ts";

export interface FightPlayerProps {
    ruffleRef: RefObject<RufflePlayerEl | null>
    frames: Frames;
    idx: number;
    onChangeIdx: ((idx: number) => void);
}

export function FightPlayer({ruffleRef, frames, idx, onChangeIdx}: FightPlayerProps) {
    const ready = useRef(false);
    const version = useRef(0);
    useEffect(() => {
        const playerRefEl = ruffleRef.current;
        if (!playerRefEl) {
            console.log("ruffleRef not ready");
            return;
        }
        const playerEl = playerRefEl;

        function next() {

            const frame = (frames.frames ?? [])[idx];
            if (!frame) {
                console.log("frame is null");
                return;
            }
            playerEl.callFlash("updateGlobalSound", frames.globalVolume);
            playerEl.callFlash("updateMapSound", frames.mapVolume);
            const versionSnapshot = version.current++;
            playerEl.callFlash("playFrame", frame, versionSnapshot);
            playerEl.updateCallback(e => {
                if (versionSnapshot !== e.version) {
                    return;
                }
                if (e.type === 'playEnd') {
                    onChangeIdx(idx + 1);
                }
            });
        }

        if (ready.current) {
            next();
        } else {
            playerEl.updateCallback(e => {
                if (e.type === 'init') {
                    ready.current = true;
                    next();
                }
            });
        }
    }, [ruffleRef, frames, idx, onChangeIdx]);
    return <div className="w-[1200px] h-[660px] relative">
        {!ready.current && <div>播放器初始化中，请稍后</div>}
        <RufflePlayer ref={ruffleRef} url={"FightPlayer.swf?silence=true"}/>
    </div>
}