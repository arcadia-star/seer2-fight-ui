import {Ref, useEffect, useImperativeHandle, useRef} from "react";

export interface FlashEvent {
    func: string,
    event: string,
    data: never
}

export interface RufflePlayerEl {
    // eslint-disable-next-line
    // @ts-expect-error
    callFlash: (name: string, ...args) => void
}

interface RufflePlayerProps {
    ref: Ref<RufflePlayerEl>,
    url: string;
    onFlashEvent: (event: FlashEvent) => void;
}

export function RufflePlayer({ref, url, onFlashEvent}: RufflePlayerProps) {
    const containerRef = useRef<HTMLDivElement>(null);
    const playerRef = useRef(null);

    useImperativeHandle(ref, () => ({
        // eslint-disable-next-line
        // @ts-ignore
        callFlash: (name: string, ...args: never[]) => playerRef.current?.[name]?.(...args)
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

        player.style.width = "100vw";
        player.style.height = "660px";
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
        window[flashCb] = onFlashEvent;
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
    }, [url, onFlashEvent]);

    return <div ref={containerRef} className="cursor-none"/>;
}
