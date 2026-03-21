<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { register } from '../api/auth';

const username = ref('');
const email = ref('');
const password = ref('');
const message = ref('');
const error = ref('');
const router = useRouter();

const handleSubmit = async () => {
  message.value = '';
  error.value = '';
  try {
    const data = await register(username.value, email.value, password.value);
    message.value = data.message || 'Registration successful!';
    setTimeout(() => router.push('/login'), 2000);
  } catch (err) {
    error.value = err.message || 'Registration failed.';
  }
};
</script>

<template>
  <div>
    <h1>Register</h1>
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
        <label for="email">Email:</label>
        <input
          type="email"
          id="email"
          v-model="email"
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
      <p v-if="message" style="color: green;">{{ message }}</p>
      <p v-if="error" style="color: red;">{{ error }}</p>
      <button type="submit">Register</button>
    </form>
  </div>
</template>

<style scoped>
/* ... */
</style>