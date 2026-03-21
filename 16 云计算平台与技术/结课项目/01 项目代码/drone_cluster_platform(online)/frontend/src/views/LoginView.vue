<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { login } from '../api/auth';

const username = ref('');
const password = ref('');
const error = ref('');
const router = useRouter();

const handleSubmit = async () => {
  error.value = '';
  try {
    const data = await login(username.value, password.value);
    localStorage.setItem('token', data.token);
    localStorage.setItem('user', JSON.stringify({
      id: data.user_id,
      username: data.username,
      role: data.role
    }));
    // 手动触发App.vue中的watchEffect，更新认证状态
    window.dispatchEvent(new Event('storage')); // 模拟localStorage变化
    router.push('/drones'); // 登录成功后跳转到无人机列表页
  } catch (err) {
    error.value = err.message || 'Login failed. Please check your credentials.';
  }
};
</script>

<template>
  <div>
    <h1>Login</h1>
    <form @submit.prevent="handleSubmit">
      <div>
        <label for="username">Username:</label>
        <input
          type="text"
          id="username"
          v-model="username"
          required
        />
      </div>
      <div>
        <label for="password">Password:</label>
        <input
          type="password"
          id="password"
          v-model="password"
          required
        />
      </div>
      <p v-if="error" style="color: red;">{{ error }}</p>
      <button type="submit">Login</button>
    </form>
  </div>
</template>

<style scoped>
/* ... */
</style>