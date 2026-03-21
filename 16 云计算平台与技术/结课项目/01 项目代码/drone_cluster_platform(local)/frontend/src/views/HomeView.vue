<script setup>
import { ref, onMounted } from 'vue';
import { useAuthStore } from '../stores/auth';
import { useRouter } from 'vue-router';
import { api } from '../api/auth';
import DroneMap from '../components/DroneMap.vue';

const authStore = useAuthStore();
const router = useRouter();

const userCount = ref(0);
const droneCount = ref(0);
const commandCount = ref(0);
const drones = ref([]);
const selectedDroneOnMap = ref(null);

// Fetch drones telemetry from backend
const fetchDronesTelemetry = async () => {
  try {
    const response = await api.get('/drones/telemetry');
    drones.value = response.data.data || [];
    console.log('Drones telemetry fetched:', drones.value);
  } catch (error) {
    console.error('Failed to fetch drones telemetry:', error);
    drones.value = [];
  }
};

// Fetch user count
const fetchUserCount = async () => {
  try {
    const response = await api.get('/users');
    userCount.value = response.data.data ? response.data.data.length : 0;
  } catch (error) {
    console.error('Failed to fetch user count:', error);
    userCount.value = 0;
  }
};

// Fetch drone count
const fetchDroneCount = async () => {
  try {
    const response = await api.get('/drones');
    droneCount.value = response.data.data ? response.data.data.length : 0;
  } catch (error) {
    console.error('Failed to fetch drone count:', error);
    droneCount.value = 0;
  }
};

// Fetch command count
const fetchCommandCount = async () => {
  try {
    const response = await api.get('/commands');
    commandCount.value = response.data.data ? response.data.data.length : 0;
  } catch (error) {
    console.error('Failed to fetch command count:', error);
    commandCount.value = 0;
  }
};

onMounted(async () => {
  await Promise.all([
    fetchUserCount(),
    fetchDroneCount(),
    fetchCommandCount(),
    fetchDronesTelemetry()
  ]);
});
</script>

<template>
  <div class="home">
    <h1>Dashboard</h1>
    <div class="stats">
      <div class="stat-card">
        <h3>Users</h3>
        <p class="stat-number">{{ userCount }}</p>
      </div>
      <div class="stat-card">
        <h3>Drones</h3>
        <p class="stat-number">{{ droneCount }}</p>
      </div>
      <div class="stat-card">
        <h3>Commands</h3>
        <p class="stat-number">{{ commandCount }}</p>
      </div>
    </div>
    
    <div class="map-container" v-if="drones.length > 0">
      <h2>Drone Map</h2>
      <DroneMap 
        :drones="drones"
        v-model:selectedDroneId="selectedDroneOnMap"
      />
    </div>
    
    <div v-else class="no-data">
      <p>No drones available</p>
    </div>
    
    <p v-if="selectedDroneOnMap" class="selected-info">
      Selected Drone ID: {{ selectedDroneOnMap }}
    </p>
  </div>
</template>

<style scoped>
.home {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.home h1 {
  margin-bottom: 30px;
  color: #333;
}

.stats {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 20px;
  margin-bottom: 30px;
}

.stat-card {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 20px;
  border-radius: 8px;
  text-align: center;
  color: white;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.stat-card h3 {
  margin: 0 0 10px 0;
  font-size: 14px;
  text-transform: uppercase;
  opacity: 0.9;
}

.stat-number {
  margin: 0;
  font-size: 32px;
  font-weight: bold;
}

.map-container {
  margin-top: 30px;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.map-container h2 {
  margin-top: 0;
  padding: 15px;
  background-color: #f5f5f5;
  border-bottom: 1px solid #ddd;
}

.no-data {
  text-align: center;
  padding: 40px;
  color: #999;
}

.selected-info {
  margin-top: 20px;
  padding: 10px;
  background-color: #f0f0f0;
  border-radius: 4px;
  color: #333;
}
</style>