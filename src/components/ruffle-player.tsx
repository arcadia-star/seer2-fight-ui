import {forwardRef, useEffect, useImperativeHandle, useRef} from "react";

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
    url: string;
    onFlashEvent: (event: FlashEvent) => void;
}

export const RufflePlayer = forwardRef(({url, onFlashEvent}: RufflePlayerProps, ref) => {
    const containerRef = useRef<HTMLDivElement>(null);
    const playerRef = useRef(null);

    useImperativeHandle(ref, () => ({
        // eslint-disable-next-line
        // @ts-ignore
        callFlash: (name: string, ...args: never[]) => playerRef.current?.[name]?.(...args)
    }));

    useEffect(() => {
        // eslint-disable-next-line
        // @ts-ignore
        const ruffle = window.RufflePlayer.newest();
        const player = ruffle.createPlayer();

        player.style.width = "1200px";
        player.style.height = "660px";
        player.config = {
            contextMenu: "off",
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
});
