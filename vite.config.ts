import path from "path"
import tailwindcss from "@tailwindcss/vite"
import react from "@vitejs/plugin-react"
import {defineConfig, searchForWorkspaceRoot} from "vite"
import {viteStaticCopy} from "vite-plugin-static-copy";
import {visualizer} from "rollup-plugin-visualizer";
import json5Plugin from "vite-plugin-json5";


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
                },
                {
                    src: 'src/_fight/**/*',
                    dest: '_fight'
                }
            ]
        }),
        json5Plugin(),
    ],
    resolve: {
        alias: {
            "@": path.resolve(__dirname, "./src"),
        },
    },
    server: {
        fs: {
            allow: [
                searchForWorkspaceRoot(process.cwd()),
            ]
        }
    }
})
