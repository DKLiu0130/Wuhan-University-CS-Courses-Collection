import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue()],
  server: {
    host: '0.0.0.0', // 允许从外部访问开发服务器
    port: 5173,      // 你的 Vite 开发服务器端口
    proxy: {
      '/api': {
        // 后端 Flask 服务在 Docker Compose 内部监听 5000 端口
        // 在 Docker Desktop 环境下 (Mac/Win)，前端开发服务器可以直接访问 host.docker.internal
        // 在纯 Linux 环境或者更复杂的网络下，可能需要指向真实的后端容器 IP 或调整网络
        // 最常见在开发时，你可能让 Flask 也在本地运行，或者通过 host.docker.internal 访问
        target: 'http://192.168.62.66:5000', // 假设后端容器的 5000 端口可以从宿主机访问
        changeOrigin: true, // 改变源
        rewrite: (path) => path.replace(/^\/api/, ''), // 重写请求路径，移除 /api 前缀
      },
    },
  },
})