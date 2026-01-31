import {Ref, useEffect, useImperativeHandle, useRef} from "react";

export interface FlashEvent {
    func: string,
    type: string,
    data: never
    version: number,
}

type FlashEventHandler = (event: FlashEvent) => void;

export interface RufflePlayerEl {
    // eslint-disable-next-line
    // @ts-expect-error
    callFlash: (name: string, ...args) => void,
    updateCallback: (cb: FlashEventHandler) => void,
    requestFullscreen: () => void,
}

interface RufflePlayerProps {
    ref: Ref<RufflePlayerEl>,
    url: string;
}

export function RufflePlayer({ref, url}: RufflePlayerProps) {
    const containerRef = useRef<HTMLDivElement>(null);
    const playerRef = useRef(null);
    const onFlashEventRef = useRef<FlashEventHandler>(null);

    useImperativeHandle(ref, () => ({
        // eslint-disable-next-line
        // @ts-ignore
        callFlash: (name: string, ...args: never[]) => {
            console.debug("callFlash", name, args);
            // eslint-disable-next-line
            // @ts-ignore
            playerRef.current?.[name]?.(...args);
        },
        updateCallback: (cb: FlashEventHandler) => onFlashEventRef.current = cb,
        // eslint-disable-next-line
        // @ts-ignore
        requestFullscreen: () => playerRef.current?.requestFullscreen(),
    }));

    useEffect(() => {
        // eslint-disable-next-line @typescript-eslint/ban-ts-comment
        // @ts-expect-error
        const Ruffle = window.RufflePlayer;
        if (!Ruffle) {
            console.error("RufflePlayer not exist");
            return;
        }
        const ruffle = Ruffle.newest();
        const player = ruffle.createPlayer();

        player.style.width = "100%";
        player.style.height = "100%";
        player.config = {
            autoplay: "on",
            unmuteOverlay: "hidden",
            splashScreen: false,
            contextMenu: "rightClickOnly",
            backgroundColor: "#00000000",
            wmode: "transparent",
            allowScriptAccess: true,
        };
        containerRef.current?.appendChild(player);

        const flashCb: string = "flash_cb_" + Math.floor(Math.random() * 100000000);
        // eslint-disable-next-line
        // @ts-ignore
        window[flashCb] = function (event: FlashEvent) {
            console.debug("flashEvent", event);
            onFlashEventRef.current?.(event);
        };
        console.log("add:" + flashCb);
        player.load(url + "?&cb=" + flashCb);
        playerRef.current = player;

        return () => {
            console.log("remove:" + flashCb);
            player.remove();
            // eslint-disable-next-line
            // @ts-ignore
            delete window[flashCb];
        };
    }, [url]);

    return <div ref={containerRef} className="w-full h-full"/>;
}
