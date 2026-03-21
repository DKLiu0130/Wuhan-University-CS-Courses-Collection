import { createApp } from 'vue';
import App from './App.vue';
import router from './router'; // 导入我们的路由配置
import './assets/main.css'; // 导入全局样式，Vue CLI项目默认可能是这个或index.css

const app = createApp(App);

app.use(router); // 使用 Vue Router
app.mount('#app');