import {Arena} from "@/components/arena.tsx";
import {Toaster} from "@/components/ui/sonner.tsx";
import {useCallback, useRef, useState} from "react";
import {randomFrames} from "@/frame-random.ts";
import {FrameType} from "@/frame.ts";

export function DemoFramePlayer() {
    const [fullFrames] = useState(() => randomFrames())
    const [frameIdx, setFrameIdx] = useState(0);
    const [playingFlag, setPlayingFlag] = useState(0);

    const arenaRef = useRef<HTMLDivElement>(null);

    const frame = fullFrames[frameIdx];
    const onFrameEnd = useCallback(() => {
        if (playingFlag) {
            return;
        }
        setTimeout(() => {
            setFrameIdx(frameIdx => Math.min(frameIdx + 1, fullFrames.length - 1));
        }, 0)
    }, [playingFlag, fullFrames]);
    const onClick = useCallback(() => {

    }, []);

    return <div>
        <Arena arenaRef={arenaRef}
               frame={frame}
               onFrameEnd={onFrameEnd}
               onClick={onClick}
        />
        {/* 进度条控制器 */}
        <div style={{margin: '24px 0 0 0', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 12}}>
            <span>帧: {frameIdx + 1} / {fullFrames.length}</span>
            <input
                type="range"
                min={0}
                max={fullFrames.length - 1}
                value={frameIdx}
                onChange={e => {
                    setFrameIdx(Number(e.target.value));
                }}
                style={{width: 300}}
            />
            <span>帧类型: {
                Object.entries(FrameType).find(([, v]) => v === frame?.type) ?.[0]
            }</span>
        </div>
        {/* 播放控制按钮 */}
        <div style={{margin: '12px 0 0 0', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 12}}>
            <button onClick={() => {
                setFrameIdx(idx => Math.max(0, idx - 1));
            }} disabled={frameIdx === 0}>上一帧
            </button>
            <button onClick={() => setPlayingFlag(p => p > 0 ? 0 : 1)}>{playingFlag == 0 ? '暂停' : '播放'}</button>
            <button onClick={() => setPlayingFlag(p => p + 1)}>重放</button>
            <button onClick={() => {
                setFrameIdx(idx => Math.min(fullFrames.length - 1, idx + 1));
            }} disabled={frameIdx === fullFrames.length - 1}>下一帧
            </button>
            <button onClick={() => console.log(arenaRef.current?.requestFullscreen())}>控制全屏</button>
            <button
                onClick={() => console.log(arenaRef.current?.querySelector("ruffle-player")?.requestFullscreen())}>动画全屏
            </button>
        </div>
        <Toaster/>
    </div>
}