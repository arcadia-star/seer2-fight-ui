import path from "path"
import tailwindcss from "@tailwindcss/vite"
import react from "@vitejs/plugin-react"
import {defineConfig} from "vite"
import {viteStaticCopy} from "vite-plugin-static-copy";
import {visualizer} from "rollup-plugin-visualizer";


// https://vite.dev/config/
export default defineConfig({
    assetsInclude: ['**/*.swf'],
    build: {
        assetsInlineLimit: 32000,
        rollupOptions: {
            output: {
                manualChunks(id) {
                    if (id.includes('node_modules')) {
                        return 'vendor'
                    }
                }
            }
        }
    },
    plugins: [
        react(),
        tailwindcss(),
        visualizer({
            open: false,
            gzipSize: true,
            brotliSize: true
        }),
        viteStaticCopy({
            targets: [
                {
                    src: 'node_modules/@ruffle-rs/ruffle/**/*',
                    dest: 'ruffle'
                }
            ]
        })
    ],
    resolve: {
        alias: {
            "@": path.resolve(__dirname, "./src"),
        },
    },
})
