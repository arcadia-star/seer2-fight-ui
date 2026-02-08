import {StrictMode} from 'react'
import {createRoot} from 'react-dom/client'
import './index.css'
// import {FramesEditor} from "@/editors/FramesEditor.tsx";
import {Player} from "@/Player.tsx";

createRoot(document.getElementById('root')!).render(
    <>
        <StrictMode>
            {/*<FramesEditor/>*/}
            <Player/>
        </StrictMode>
    </>,
)
