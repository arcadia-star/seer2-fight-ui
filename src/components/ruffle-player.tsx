import { type Ref, useEffect, useImperativeHandle, useRef } from 'react';

export interface FlashEvent {
    func: string;
    type: string;
    data: unknown;
    version: number | null;
}
type FlashEventHandler = (event: FlashEvent) => void;
interface RuffleElement extends HTMLElement {
    config: Record<string, unknown>;
    load(url: string): Promise<void>;
}
export interface RufflePlayerEl {
    callFlash: (name: string, ...args: unknown[]) => unknown;
    updateCallback: (callback: FlashEventHandler) => void;
    requestFullscreen: () => void;
}
interface RufflePlayerProps {
    ref: Ref<RufflePlayerEl>;
    url: string;
    onError?: (message: string) => void;
}

export function RufflePlayer({ ref, url, onError }: RufflePlayerProps) {
    const container = useRef<HTMLDivElement>(null);
    const player = useRef<RuffleElement | null>(null);
    const callback = useRef<FlashEventHandler | null>(null);
    const errorHandler = useRef(onError);
    errorHandler.current = onError;
    useImperativeHandle(ref, () => ({
        callFlash(name, ...args) {
            const method = (player.current as unknown as Record<string, unknown>)[name];
            if (typeof method !== 'function') {
                throw new Error(`Flash接口尚未就绪：${name}`);
            }
            return method.apply(player.current, args);
        },
        updateCallback: (handler) => {
            callback.current = handler;
        },
        requestFullscreen: () => {
            void player.current!.requestFullscreen();
        },
    }));
    useEffect(() => {
        const globals = window as unknown as Record<string, unknown>;
        const ruffle = globals.RufflePlayer as { newest(): { createPlayer(): RuffleElement } };
        const element = ruffle.newest().createPlayer();
        const name = `flash_cb_${crypto.randomUUID().replace(/-/g, '')}`;
        globals[name] = (event: FlashEvent) => {
            console.debug('Flash event', event);
            if (event.type === 'error') {
                errorHandler.current?.(String(event.data));
            }
            callback.current?.(event);
        };
        element.style.width = '100%';
        element.style.height = '100%';
        element.config = {
            autoplay: 'on',
            unmuteOverlay: 'hidden',
            splashScreen: false,
            contextMenu: 'rightClickOnly',
            backgroundColor: '#00000000',
            wmode: 'transparent',
            allowScriptAccess: true,
        };
        container.current!.appendChild(element);
        player.current = element;
        const source = new URL(url, document.baseURI);
        source.searchParams.set('cb', name);
        let disposed = false;
        void element.load(source.href).catch((error) => {
            if (!disposed) {
                console.error(error);
                errorHandler.current?.(`战斗播放器加载失败：${(error as Error).message}`);
            }
        });
        return () => {
            disposed = true;
            element.remove();
            delete globals[name];
            player.current = null;
        };
    }, [url]);
    return <div ref={container} className="w-full h-full" />;
}
