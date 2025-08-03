import {DemoFramePlayer} from "@/demo-frame-player.tsx";
import {DemoGamePlayer} from "@/demo-game-player.tsx";
import {useState} from "react";

function App() {
    const [mode, setMode] = useState(1)

    const handleGithubClick = () => {
        window.open('https://github.com/arcadia-star/seer2-fight-ui', '_blank');
    };

    return <div>
        {mode === 1 && <DemoGamePlayer/>}
        {mode === 2 && <DemoFramePlayer/>}

        {/* 控制按钮区域 */}
        <div
            className="flex justify-center items-center gap-4 p-6 ">
            {/* 模式切换按钮 */}
            <button
                className="group relative overflow-hidden px-6 py-3 bg-gradient-to-r from-blue-500 to-blue-600 hover:from-blue-600 hover:to-blue-700 text-white font-semibold rounded-lg shadow-lg hover:shadow-xl transform hover:scale-105 transition-all duration-300 ease-out"
                onClick={() => setMode(mode === 1 ? 2 : 1)}
            >
                <span className="relative z-10 flex items-center gap-2">
                    <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2}
                              d="M7 16V4m0 0L3 8m4-4l4 4m6 0v12m0 0l4-4m-4 4l-4-4"/>
                    </svg>
                    切换到{mode === 1 ? '操作模式' : '播放模式'}
                </span>
                <div
                    className="absolute inset-0 bg-white opacity-0 group-hover:opacity-10 transition-opacity duration-300"></div>
            </button>

            {/* Github链接按钮 */}
            <button
                className="group relative overflow-hidden px-6 py-3 bg-gradient-to-r from-gray-700 to-gray-800 hover:from-gray-800 hover:to-gray-900 text-white font-medium rounded-lg shadow-md hover:shadow-lg transform hover:scale-105 transition-all duration-300 ease-out flex items-center gap-2"
                onClick={handleGithubClick}
            >
                <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 24 24">
                    <path
                        d="M12 0C5.374 0 0 5.373 0 12 0 17.302 3.438 21.8 8.207 23.387c.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23A11.509 11.509 0 0112 5.803c1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576C20.566 21.797 24 17.3 24 12c0-6.627-5.373-12-12-12z"/>
                </svg>
                <span className="relative z-10">查看源码</span>
                <div
                    className="absolute inset-0 bg-white opacity-0 group-hover:opacity-10 transition-opacity duration-300"></div>
            </button>
        </div>
    </div>
}

export default App