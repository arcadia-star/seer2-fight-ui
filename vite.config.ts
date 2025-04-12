import path from "path"
import tailwindcss from "@tailwindcss/vite"
import react from "@vitejs/plugin-react"
import {defineConfig} from "vite"


// https://vite.dev/config/
export default defineConfig({
    assetsInclude: ['**/*.swf'],
    build: {
        assetsInlineLimit: 10000,
    },
    plugins: [react(), tailwindcss()],
    resolve: {
        alias: {
            "@": path.resolve(__dirname, "./src"),
        },
    },
})
