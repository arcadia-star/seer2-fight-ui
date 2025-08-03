import {ReactNode, useCallback, useEffect, useRef, useState} from 'react';
import {Maximize, Maximize2, X} from 'lucide-react';

interface FullscreenProps {
    children: ReactNode;
    originalWidth: number;
    originalHeight: number;
}

export function Fullscreen({children, originalWidth, originalHeight,}: FullscreenProps) {
    const [isFullscreen, setIsFullscreen] = useState(false);
    const [scale, setScale] = useState(1);

    const containerRef = useRef<HTMLDivElement>(null);
    const scalingRef = useRef<HTMLDivElement>(null);

    const aspectRatio = originalWidth / originalHeight;

    // 计算缩放比例
    const updateScaling = useCallback(() => {
        if (!isFullscreen) return;

        const containerWidth = window.innerWidth;
        const containerHeight = window.innerHeight;

        const widthRatio = containerWidth / originalWidth;
        const heightRatio = containerHeight / originalHeight;
        const newScale = Math.min(widthRatio, heightRatio);

        setScale(newScale);
    }, [isFullscreen, originalHeight, originalWidth]);

    // 进入全屏
    const enterFullscreen = () => {
        setIsFullscreen(true);
        // 延迟更新缩放，确保容器已经显示
        setTimeout(updateScaling, 50);
    };

    // 退出全屏
    const exitFullscreen = () => {
        setIsFullscreen(false);
        if (document.fullscreenElement) {
            document.exitFullscreen().then();
        }
    };

    // 监听窗口大小变化
    useEffect(() => {
        const handleResize = () => {
            if (isFullscreen) {
                updateScaling();
            }
        };

        window.addEventListener('resize', handleResize);
        return () => window.removeEventListener('resize', handleResize);
    }, [isFullscreen, updateScaling]);

    // 监听ESC键退出全屏
    useEffect(() => {
        const handleKeyDown = (event: KeyboardEvent) => {
            if (event.key === 'Escape' && isFullscreen) {
                exitFullscreen();
            }
        };

        document.addEventListener('keydown', handleKeyDown);
        return () => document.removeEventListener('keydown', handleKeyDown);
    }, [isFullscreen]);

    // 当进入全屏时更新缩放
    useEffect(() => {
        if (isFullscreen) {
            updateScaling();
        }
    }, [isFullscreen, updateScaling]);

    return (
        <div ref={containerRef}>
            {/* 主容器 - children始终在这里渲染 */}
            <div className="relative">
                <div
                    ref={scalingRef}
                    className={`transition-all duration-400 ${
                        isFullscreen
                            ? 'fixed inset-0 z-50 flex items-center justify-center'
                            : 'relative'
                    }`}
                    style={{
                        backgroundColor: isFullscreen ? 'rgba(0, 0, 0, 0.95)' : 'transparent',
                        // 确保全屏时有足够空间显示缩放内容
                        overflow: isFullscreen ? 'visible' : 'visible'
                    }}
                >
                    {/* children容器 - 只渲染一次 */}
                    <div
                        className={`transition-all duration-300 ${
                            isFullscreen
                                ? 'rounded-lg shadow-xl'
                                : ''
                        }`}
                        style={{
                            width: originalWidth,
                            height: originalHeight,
                            transform: isFullscreen ? `scale(${scale})` : 'scale(1)',
                            transformOrigin: 'center center',
                            // 确保内容不被裁剪
                            overflow: 'visible'
                        }}
                    >
                        {children}
                    </div>
                </div>

                {/* 进入全屏按钮 - 只在非全屏时显示 */}
                {!isFullscreen && (
                    <button
                        onClick={enterFullscreen}
                        className="absolute top-2 right-2 w-10 h-10 bg-black/20 hover:bg-black/30 rounded-full flex items-center justify-center text-white transition-all duration-300 hover:scale-110 z-10"
                        title="进入全屏模式"
                    >
                        <Maximize2 size={20}/>
                    </button>
                )}
            </div>

            {/* 全屏模式的UI元素 */}
            {isFullscreen && (
                <div className="fixed inset-0 z-50 pointer-events-none">
                    {/* 关闭按钮 */}
                    <button
                        onClick={exitFullscreen}
                        className="absolute top-5 right-5 w-12 h-12 bg-white/20 hover:bg-white/30 rounded-full flex items-center justify-center text-white text-xl transition-all duration-300 hover:rotate-90 z-10 pointer-events-auto"
                    >
                        <X size={24}/>
                    </button>
                    {/* 全屏按钮 */}
                    <button
                        onClick={() => {
                            if (document.fullscreenElement) {
                                document.exitFullscreen().then();
                            } else {
                                containerRef.current?.requestFullscreen().then();
                            }
                        }}
                        className="absolute top-20 right-5 w-12 h-12 bg-white/20 hover:bg-white/30 rounded-full flex items-center justify-center text-white text-xl transition-all duration-300 hover:rotate-90 z-10 pointer-events-auto"
                    >
                        <Maximize size={24}/>
                    </button>

                    {/* 缩放比例显示 */}
                    <div className="absolute top-5 left-5 bg-black/60 px-4 py-2 rounded text-white text-sm z-10">
                        缩放比例: {scale.toFixed(2)}x
                    </div>

                    {/* 原始比例显示 */}
                    <div className="absolute bottom-5 right-5 bg-black/60 px-4 py-2 rounded text-white text-sm">
                        原始比例: {aspectRatio.toFixed(2)}:1
                    </div>
                </div>
            )}
        </div>
    );
}