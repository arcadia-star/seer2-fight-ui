import {DemoFramePlayer} from "@/demo-frame-player.tsx";
import {DemoGamePlayer} from "@/demo-game-player.tsx";
import {useState} from "react";

function App() {
    const [mode, setMode] = useState(1)
    return <div>
        {mode === 1 && <DemoGamePlayer/>}
        {mode === 2 && <DemoFramePlayer/>}
        <div className="text-center cursor-pointer" onClick={() => setMode(mode === 1 ? 2 : 1)}>
            {mode === 1 ? '播放模式' : '操作模式'}
        </div>
    </div>
}

export default App