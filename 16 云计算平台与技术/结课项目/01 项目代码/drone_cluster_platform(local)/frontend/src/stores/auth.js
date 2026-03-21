
// frontend/src/stores/auth.js
import { defineStore } from 'pinia';
import { ref } from 'vue';

export const useAuthStore = defineStore('auth', () => {
  const token = ref(localStorage.getItem('token') || null);
  const isAuthenticated = ref(!!token.value);

  function setAuthData(newToken) {
    token.value = newToken;
    isAuthenticated.value = true;
    localStorage.setItem('token', newToken);
  }

  function clearAuthData() {
    token.value = null;
    isAuthenticated.value = false;
    localStorage.removeItem('token');
  }

  return { token, isAuthenticated, setAuthData, clearAuthData };
});
