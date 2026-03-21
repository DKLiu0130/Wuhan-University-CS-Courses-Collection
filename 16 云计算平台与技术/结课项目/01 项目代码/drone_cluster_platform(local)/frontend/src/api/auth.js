// frontend/src/api/auth.js
import axios from 'axios';
import router from '../router'; // 导入 router 实例用于重定向

const API_BASE_URL = '/api'; // 确保与后端服务端口一致

// *** 修改这里：添加 'export' ***
export const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response && error.response.status === 401) {
      console.error('Unauthorized request - Token might be expired or invalid.');
      localStorage.removeItem('token');
      localStorage.removeItem('user');
      // 使用 Vue Router 实例进行重定向
      router.push('/login');
    }
    return Promise.reject(error);
  }
);

export const login = async (username, password) => {
  try {
    const response = await api.post('/login', { username, password });
    return response.data;
  } catch (error) {
    throw error.response?.data || error.message;
  }
};

export const register = async (username, email, password) => {
  try {
    const response = await api.post('/register', { username, email, password });
    return response.data;
  } catch (error) {
    throw error.response?.data || error.message;
  }
};

// --- 无人机相关的 API 函数 ---

export const getDrones = async (includeTelemetry = false) => {
  try {
    const response = await api.get('/drones', {
      params: { include_telemetry: includeTelemetry }
    });
    return response.data;
  } catch (error) {
    throw error.response?.data || error.message;
  }
};

export const getDroneById = async (droneId, includeTelemetry = true) => {
  try {
    const response = await api.get(`/drones/${droneId}`, {
      params: { include_telemetry: includeTelemetry }
    });
    return response.data;
  } catch (error) {
    throw error.response?.data || error.message;
  }
};

export const createDrone = async (droneData) => {
  try {
    const response = await api.post('/drones', droneData);
    return response.data;
  } catch (error) {
    throw error.response?.data || error.message;
  }
};

export const updateDrone = async (droneId, droneData) => {
  try {
    const response = await api.put(`/drones/${droneId}`, droneData);
    return response.data;
  } catch (error) {
    throw error.response?.data || error.message;
  }
};

export const deleteDrone = async (droneId) => {
  try {
    const response = await api.delete(`/drones/${droneId}`);
    return response.data;
  } catch (error) {
    throw error.response?.data || error.message;
  }
};

// --- 遥测相关的 API 函数 ---

export const uploadTelemetry = async (droneId, telemetryData) => {
  try {
    const response = await api.post(`/drones/${droneId}/telemetry`, telemetryData);
    return response.data;
  } catch (error) {
    throw error.response?.data || error.message;
  }
};

export const getLatestTelemetry = async (droneId) => {
  try {
    const response = await api.get(`/drones/${droneId}/telemetry/latest`);
    return response.data;
  } catch (error) {
    throw error.response?.data || error.message;
  }
};

// --- 指令相关的 API 函数 ---

export const issueCommand = async (droneId, commandData) => {
  try {
    const response = await api.post(`/drones/${droneId}/commands`, commandData);
    return response.data;
  } catch (error) {
    throw error.response?.data || error.message;
  }
};

export const getDroneCommands = async (droneId) => {
  try {
    const response = await api.get(`/drones/${droneId}/commands`);
    return response.data;
  } catch (error) {
    throw error.response?.data || error.message;
  }
};

export const updateCommandStatus = async (commandId, statusData) => {
  try {
    const response = await api.put(`/commands/${commandId}/status`, statusData);
    return response.data;
  } catch (error) {
    throw error.response?.data || error.message;
  }
};

// --- 通用 API 函数 (例如，用于 ProtectedRoute 验证) ---
export const getProtectedData = async () => {
  try {
    const response = await api.get('/protected');
    return response.data;
  } catch (error) {
    throw error.response?.data || error.message;
  }
};
