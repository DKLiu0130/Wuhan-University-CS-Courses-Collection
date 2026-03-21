<script setup>
import { ref, watchEffect } from 'vue';
import { RouterLink, RouterView, useRouter } from 'vue-router';

const isAuthenticated = ref(false);
const user = ref(null);
const router = useRouter();

// watchEffect 会立即运行一次，并在其响应式依赖发生变化时重新运行
watchEffect(() => {
  const token = localStorage.getItem('token');
  const storedUser = localStorage.getItem('user');

  isAuthenticated.value = !!token; // 转换为布尔值
  if (storedUser) {
    try {
      user.value = JSON.parse(storedUser);
    } catch (e) {
      console.error("Failed to parse user data from localStorage", e);
      localStorage.removeItem('user');
      localStorage.removeItem('token');
      isAuthenticated.value = false;
      user.value = null;
    }
  } else {
    user.value = null;
  }
});

const handleLogout = () => {
  localStorage.removeItem('token');
  localStorage.removeItem('user');
  isAuthenticated.value = false;
  user.value = null;
  router.push('/login'); // 登出后重定向到登录页
};
</script>

<template>
  <div id="app">
    <nav class="App-nav">
      <RouterLink to="/">Home</RouterLink>
      <template v-if="!isAuthenticated">
        <RouterLink to="/login">Login</RouterLink>
        <RouterLink to="/register">Register</RouterLink>
      </template>
      <template v-else>
        <RouterLink to="/drones">Drones</RouterLink>
        <span>Welcome, {{ user?.username }} ({{ user?.role }})!</span>
        <button @click="handleLogout">Logout</button>
      </template>
    </nav>

    <main class="App-main">
      <RouterView />
    </main>
  </div>
</template>
