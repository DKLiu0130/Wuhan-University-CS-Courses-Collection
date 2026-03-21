import { createRouter, createWebHistory } from 'vue-router';

// 导入页面组件 (待创建)
import HomeView from '../views/HomeView.vue';
import LoginView from '../views/LoginView.vue';
import RegisterView from '../views/RegisterView.vue';
import DroneListView from '../views/DroneListView.vue';
import DroneDetailView from '../views/DroneDetailView.vue';

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL), // for Vue 3 Vite projects
  // For Vue CLI (Webpack) projects, it's usually `createWebHistory()`
  // If you're using Vue CLI 4, you might see `history: createWebHistory(process.env.BASE_URL)`
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView
    },
    {
      path: '/login',
      name: 'login',
      component: LoginView
    },
    {
      path: '/register',
      name: 'register',
      component: RegisterView
    },
    {
      path: '/drones',
      name: 'droneList',
      component: DroneListView,
      meta: { requiresAuth: true } // 需要认证的路由
    },
    {
      path: '/drones/:id',
      name: 'droneDetail',
      component: DroneDetailView,
      meta: { requiresAuth: true } // 需要认证的路由
    },
    {
      path: '/:pathMatch(.*)*', // 404 catch-all route
      name: 'NotFound',
      component: { template: '<h1>404 Not Found</h1>' }
    }
  ]
});

// 路由守卫：检查认证状态
router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('token');
  if (to.meta.requiresAuth && !token) {
    // 如果路由需要认证但没有 token，则重定向到登录页
    next('/login');
  } else if ((to.name === 'login' || to.name === 'register') && token) {
    // 如果已登录但尝试访问登录/注册页，则重定向到主页或无人机列表
    next('/drones');
  } else {
    next(); // 继续导航
  }
});

export default router;