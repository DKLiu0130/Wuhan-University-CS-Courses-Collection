<script setup>
import { ref, onMounted } from 'vue';
import { getDrones, createDrone } from '../api/auth';
import { RouterLink, useRouter } from 'vue-router';

const drones = ref([]);
const loading = ref(true);
const error = ref('');
const showCreateForm = ref(false);
const newDroneData = ref({
  name: '',
  serial_number: '',
  model: '',
  home_latitude: '',
  home_longitude: '',
  video_feed_url: ''
});
const router = useRouter();

onMounted(() => {
  fetchDrones();
});

const fetchDrones = async () => {
  loading.value = true;
  error.value = '';
  try {
    const data = await getDrones(true); // 包含遥测数据
    drones.value = data;
  } catch (err) {
    error.value = err.message || 'Failed to fetch drones.';
    console.error("Error fetching drones:", err);
    if (err && (err.message === 'Unauthorized' || err.message?.includes('401'))) {
      router.push('/login');
    }
  } finally {
    loading.value = false;
  }
};

const handleCreateFormChange = (e) => {
  const { name, value } = e.target;
  newDroneData.value[name] = value;
};

const handleCreateDrone = async () => {
  error.value = '';
  try {
    const payload = {
      ...newDroneData.value,
      home_latitude: newDroneData.value.home_latitude ? parseFloat(newDroneData.value.home_latitude) : null,
      home_longitude: newDroneData.value.home_longitude ? parseFloat(newDroneData.value.home_longitude) : null,
    };
    await createDrone(payload);
    alert('Drone created successfully!');
    showCreateForm.value = false;
    newDroneData.value = { // 重置表单
      name: '', serial_number: '', model: '',
      home_latitude: '', home_longitude: '', video_feed_url: ''
    };
    fetchDrones(); // 重新加载列表
  } catch (err) {
    error.value = err.message || 'Failed to create drone.';
    console.error("Error creating drone:", err);
  }
};
</script>

<template>
  <div>
    <h1>Drone List</h1>

    <button @click="showCreateForm = !showCreateForm">
      {{ showCreateForm ? 'Hide Create Form' : 'Add New Drone' }}
    </button>

    <div v-if="showCreateForm" style="margin-bottom: 20px; padding: 15px; border: 1px solid #ccc; border-radius: 8px; background-color: #f9f9f9;">
      <h2>Create New Drone</h2>
      <form @submit.prevent="handleCreateDrone">
        <div>
          <label>Name:</label>
          <input type="text" name="name" v-model="newDroneData.name" @input="handleCreateFormChange" required />
        </div>
        <div>
          <label>Serial Number:</label>
          <input type="text" name="serial_number" v-model="newDroneData.serial_number" @input="handleCreateFormChange" required />
        </div>
        <div>
          <label>Model:</label>
          <input type="text" name="model" v-model="newDroneData.model" @input="handleCreateFormChange" />
        </div>
        <div>
          <label>Home Latitude:</label>
          <input type="number" step="any" name="home_latitude" v-model="newDroneData.home_latitude" @input="handleCreateFormChange" />
        </div>
        <div>
          <label>Home Longitude:</label>
          <input type="number" step="any" name="home_longitude" v-model="newDroneData.home_longitude" @input="handleCreateFormChange" />
        </div>
        <div>
          <label>Video Feed URL:</label>
          <input type="text" name="video_feed_url" v-model="newDroneData.video_feed_url" @input="handleCreateFormChange" />
        </div>
        <button type="submit">Create Drone</button>
      </form>
    </div>

    <div v-if="loading">Loading drones...</div>
    <div v-else-if="error" style="color: red;">Error: {{ error }}</div>
    <div v-else-if="drones.length === 0">
      <p>No drones found. Add one above!</p>
    </div>
    <ul v-else style="list-style-type: none; padding: 0;">
      <li v-for="drone in drones" :key="drone.id" style="
        border: 1px solid #eee;
        border-radius: 8px;
        padding: 15px;
        margin-bottom: 10px;
        background-color: #fff;
        text-align: left;
      ">
        <h2>
          <RouterLink :to="`/drones/${drone.id}`" style="text-decoration: none; color: #282c34;">
            {{ drone.name }} ({{ drone.serial_number }})
          </RouterLink>
        </h2>
        <p><strong>Model:</strong> {{ drone.model || 'N/A' }}</p>
        <p><strong>Status:</strong> <span :style="{ color: drone.status === 'online' ? 'green' : 'orange' }">{{ drone.status }}</span></p>
        <div v-if="drone.latest_telemetry" style="font-size: 0.9em; color: #555;">
          <p><strong>Latest Telemetry:</strong></p>
          <ul>
            <li>Lat: {{ drone.latest_telemetry.current_latitude }}, Lon: {{ drone.latest_telemetry.current_longitude }}</li>
            <li>Altitude: {{ drone.latest_telemetry.current_altitude }}m</li>
            <li>Speed: {{ drone.latest_telemetry.speed }}m/s</li>
            <li>Battery: {{ drone.latest_telemetry.battery_level }}%</li>
            <li>Mode: {{ drone.latest_telemetry.flight_mode }}</li>
            <li>Updated: {{ new Date(drone.latest_telemetry.updated_at).toLocaleString() }}</li>
          </ul>
        </div>
        <p v-else style="font-size: 0.9em; color: #888;">No latest telemetry data available.</p>
      </li>
    </ul>
  </div>
</template>

<style scoped>
/* ... */
</style>