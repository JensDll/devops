import url from 'node:url'

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

const srcPath = url.fileURLToPath(new url.URL('./src', import.meta.url))

export default defineConfig({
  resolve: {
    alias: {
      '~': srcPath
    }
  },
  plugins: [vue()]
})
