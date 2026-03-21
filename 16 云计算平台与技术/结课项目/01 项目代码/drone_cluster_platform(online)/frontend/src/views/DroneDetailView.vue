<script setup>
import { ref, onMounted, onUnmounted, computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { getDroneById, updateDrone, deleteDrone, issueCommand, getLatestTelemetry, getDroneCommands, updateCommandStatus, uploadTelemetry } from '../api/auth';

const route = useRoute();
const router = useRouter();
const droneId = route.params.id;

const drone = ref(null);
const telemetry = ref(null);
const commands = ref([]);
const editing = ref(false);
const updatedDroneData = ref({});
const commandData = ref({
  command_type: 'hover',
  target_latitude: '',
  target_longitude: '',
  target_altitude: ''
});
const uploadTelemetryData = ref({
  current_latitude: '',
  current_longitude: '',
  current_altitude: '',
  speed: '',
  battery_level: '',
  flight_mode: 'manual',
  is_flying: false
});
const loading = ref(true);
const error = ref('');
const message = ref('');
let refreshInterval = null; // 用于存储定时器ID

// 获取当前登录用户的信息 (从 localStorage 读取)
const currentUser = computed(() => {
  const storedUser = localStorage.getItem('user');
  return storedUser ? JSON.parse(storedUser) : null;
});

onMounted(() => {
  fetchDroneDetails();
  refreshInterval = setInterval(fetchDroneTelemetryAndCommands, 5000); // 每5秒刷新
});

onUnmounted(() => {
  if (refreshInterval) {
    clearInterval(refreshInterval); // 清理定时器
  }
});

const fetchDroneDetails = async () => {
  setLoading(true);
  error.value = '';
  try {
    const droneData = await getDroneById(droneId, true);
    drone.value = droneData;
    telemetry.value = droneData.latest_telemetry;
    updatedDroneData.value = {
      name: droneData.name,
      model: droneData.model,
      status: droneData.status,
      home_latitude: droneData.home_latitude,
      home_longitude: droneData.home_longitude,
      video_feed_url: droneData.video_feed_url
    };

    if (droneData.latest_telemetry) {
      uploadTelemetryData.value = {
          current_latitude: parseFloat(droneData.latest_telemetry.current_latitude),
          current_longitude: parseFloat(droneData.latest_telemetry.current_longitude),
          current_altitude: parseFloat(droneData.latest_telemetry.current_altitude),
          speed: parseFloat(droneData.latest_telemetry.speed),
          battery_level: droneData.latest_telemetry.battery_level,
          flight_mode: droneData.latest_telemetry.flight_mode,
          is_flying: droneData.latest_telemetry.is_flying
      };
    } else {
       uploadTelemetryData.value = {
          current_latitude: droneData.home_latitude ? parseFloat(droneData.home_latitude) : 0,
          current_longitude: droneData.home_longitude ? parseFloat(droneData.home_longitude) : 0,
          current_altitude: 0,
          speed: 0,
          battery_level: 100,
          flight_mode: 'manual',
          is_flying: false
      };
    }

    await fetchDroneCommands();
  } catch (err) {
    error.value = err.message || 'Failed to fetch drone details.';
    console.error("Error fetching drone details:", err);
    if (err && (err.message === 'Unauthorized' || err.message?.includes('401'))) {
      router.push('/login');
    }
  } finally {
    setLoading(false);
  }
};

const fetchDroneTelemetryAndCommands = async () => {
  try {
    const latestTelemetry = await getLatestTelemetry(droneId);
    telemetry.value = latestTelemetry;

    if (latestTelemetry) {
      uploadTelemetryData.value = {
          current_latitude: parseFloat(latestTelemetry.current_latitude),
          current_longitude: parseFloat(latestTelemetry.current_longitude),
          current_altitude: parseFloat(latestTelemetry.current_altitude),
          speed: parseFloat(latestTelemetry.speed),
          battery_level: latestTelemetry.battery_level,
          flight_mode: latestTelemetry.flight_mode,
          is_flying: latestTelemetry.is_flying
      };
    }

    await fetchDroneCommands();
  } catch (err) {
    console.warn("Failed to auto-refresh telemetry or commands:", err.message);
  }
};

const fetchDroneCommands = async () => {
  try {
    const cmds = await getDroneCommands(droneId);
    commands.value = cmds;
  } catch (err) {
    console.error("Error fetching drone commands:", err);
  }
};

const handleUpdateChange = (e) => {
  const { name, value } = e.target;
  updatedDroneData.value[name] = value;
};

const handleUpdateSubmit = async () => {
  error.value = '';
  try {
    await updateDrone(droneId, updatedDroneData.value);
    message.value = 'Drone updated successfully!';
    editing.value = false;
    fetchDroneDetails();
  } catch (err) {
    error.value = err.message || 'Failed to update drone.';
    console.error("Error updating drone:", err);
  }
};

const handleDroneDelete = async () => {
  if (window.confirm(`Are you sure you want to delete drone "${drone.value.name}"?`)) {
    error.value = '';
    try {
      await deleteDrone(droneId);
      alert('Drone deleted successfully!');
      router.push('/drones');
    } catch (err) {
      error.value = err.message || 'Failed to delete drone.';
      console.error("Error deleting drone:", err);
    }
  }
};

const handleCommandChange = (e) => {
  const { name, value } = e.target;
  commandData.value[name] = value;
};

const handleIssueCommand = async () => {
  error.value = '';
  try {
    const payload = {
      ...commandData.value,
      target_latitude: commandData.value.target_latitude ? parseFloat(commandData.value.target_latitude) : null,
      target_longitude: commandData.value.target_longitude ? parseFloat(commandData.value.target_longitude) : null,
      target_altitude: commandData.value.target_altitude ? parseFloat(commandData.value.target_altitude) : null,
    };
    await issueCommand(droneId, payload);
    message.value = 'Command issued successfully!';
    commandData.value = { command_type: 'hover', target_latitude: '', target_longitude: '', target_altitude: '' };
    fetchDroneCommands();
  } catch (err) {
    error.value = err.message || 'Failed to issue command.';
    console.error("Error issuing command:", err);
  }
};

const handleUpdateCommandStatus = async (commandIdToUpdate, newStatus) => {
  error.value = '';
  try {
    await updateCommandStatus(commandIdToUpdate, { status: newStatus });
    message.value = `Command ${commandIdToUpdate} status updated to ${newStatus}.`;
    fetchDroneCommands();
  } catch (err) {
    error.value = err.message || 'Failed to update command status.';
    console.error("Error updating command status:", err);
  }
};

const handleUploadTelemetryChange = (e) => {
  const { name, value, type, checked } = e.target;
  uploadTelemetryData.value[name] = type === 'checkbox' ? checked : value;
};

const handleSimulateTelemetryUpload = async () => {
    error.value = '';
    try {
        const payload = {
            ...uploadTelemetryData.value,
            current_latitude: parseFloat(uploadTelemetryData.value.current_latitude),
            current_longitude: parseFloat(uploadTelemetryData.value.current_longitude),
            current_altitude: parseFloat(uploadTelemetryData.value.current_altitude),
            speed: parseFloat(uploadTelemetryData.value.speed),
            battery_level: parseInt(uploadTelemetryData.value.battery_level),
        };
        await uploadTelemetry(droneId, payload);
        message.value = 'Telemetry simulated and uploaded successfully!';
        fetchDroneDetails();
    } catch (err) {
        error.value = err.message || 'Failed to simulate telemetry upload.';
        console.error("Error simulating telemetry upload:", err);
    }
};

const setLoading = (val) => {
  loading.value = val;
};
</script>

<template>
  <div v-if="loading">Loading drone details...</div>
  <div v-else-if="error" style="color: red;">Error: {{ error }}</div>
  <div v-else-if="!drone">Drone not found.</div>
  <div v-else>
    <h1>{{ drone.name }} ({{ drone.serial_number }})</h1>
    <p v-if="message" style="color: green;">{{ message }}</p>
    <p v-if="error" style="color: red;">{{ error }}</p>

    <section class="drone-info" style="margin-bottom: 20px; text-align: left; border: 1px solid #ddd; padding: 15px; border-radius: 8px;">
      <h2>Drone Information</h2>
      <p><strong>ID:</strong> {{ drone.id }}</p>
      <p><strong>Model:</strong> {{ drone.model }}</p>
      <p><strong>Status:</strong> <span :style="{ color: drone.status === 'online' ? 'green' : 'orange' }">{{ drone.status }}</span></p>
      <p><strong>Home Location:</strong> Lat {{ drone.home_latitude }}, Lon {{ drone.home_longitude }}</p>
      <p><strong>Video Feed URL:</strong> {{ drone.video_feed_url || 'N/A' }}</p>
      <p><strong>Created At:</strong> {{ new Date(drone.created_at).toLocaleString() }}</p>
      <p><strong>Last Config Update:</strong> {{ new Date(drone.last_config_update).toLocaleString() }}</p>
      <button @click="editing = !editing">{{ editing ? 'Cancel Edit' : 'Edit Drone' }}</button>
      <button @click="handleDroneDelete" style="background-color: #dc3545; margin-left: 10px;">Delete Drone</button>

      <form v-if="editing" @submit.prevent="handleUpdateSubmit" style="margin-top: 20px; padding: 15px; border: 1px solid #eee; border-radius: 8px; background-color: #f9f9f9;">
        <h3>Edit Drone Information</h3>
        <div>
          <label>Name:</label>
          <input type="text" name="name" v-model="updatedDroneData.name" @input="handleUpdateChange" required />
        </div>
        <div>
          <label>Model:</label>
          <input type="text" name="model" v-model="updatedDroneData.model" @input="handleUpdateChange" />
        </div>
        <div>
          <label>Status:</label>
          <select name="status" v-model="updatedDroneData.status" @change="handleUpdateChange">
            <option value="online">Online</option>
            <option value="offline">Offline</option>
            <option value="flying">Flying</option>
            <option value="maintenance">Maintenance</option>
          </select>
        </div>
        <div>
          <label>Home Latitude:</label>
          <input type="number" step="any" name="home_latitude" v-model="updatedDroneData.home_latitude" @input="handleUpdateChange" />
        </div>
        <div>
          <label>Home Longitude:</label>
          <input type="number" step="any" name="home_longitude" v-model="updatedDroneData.home_longitude" @input="handleUpdateChange" />
        </div>
        <div>
          <label>Video Feed URL:</label>
          <input type="text" name="video_feed_url" v-model="updatedDroneData.video_feed_url" @input="handleUpdateChange" />
        </div>
        <button type="submit">Save Changes</button>
      </form>
    </section>

    <section class="telemetry-data" style="margin-bottom: 20px; text-align: left; border: 1px solid #ddd; padding: 15px; border-radius: 8px;">
      <h2>Latest Telemetry Data</h2>
      <ul v-if="telemetry">
        <li><strong>Current Location:</strong> Lat {{ telemetry.current_latitude }}, Lon {{ telemetry.current_longitude }}</li>
        <li><strong>Altitude:</strong> {{ telemetry.current_altitude }}m</li>
        <li><strong>Speed:</strong> {{ telemetry.speed }}m/s</li>
        <li><strong>Battery Level:</strong> {{ telemetry.battery_level }}%</li>
        <li><strong>Flight Mode:</strong> {{ telemetry.flight_mode }}</li>
        <li><strong>Is Flying:</strong> {{ telemetry.is_flying ? 'Yes' : 'No' }}</li>
        <li><strong>Error:</strong> {{ telemetry.error_message || 'None' }}</li>
        <li><strong>Last Updated:</strong> {{ new Date(telemetry.updated_at).toLocaleString() }}</li>
      </ul>
      <p v-else>No telemetry data available for this drone.</p>

      <div style="margin-top: 20px; padding: 15px; border: 1px solid #eee; border-radius: 8px; background-color: #f9f9f9; text-align: left;">
          <h3>Simulate Telemetry Upload (For testing only)</h3>
          <form @submit.prevent="handleSimulateTelemetryUpload">
              <div>
                  <label>Latitude:</label>
                  <input type="number" step="any" name="current_latitude" v-model="uploadTelemetryData.current_latitude" @input="handleUploadTelemetryChange" required />
              </div>
              <div>
                  <label>Longitude:</label>
                  <input type="number" step="any" name="current_longitude" v-model="uploadTelemetryData.current_longitude" @input="handleUploadTelemetryChange" required />
              </div>
              <div>
                  <label>Altitude (m):</label>
                  <input type="number" step="any" name="current_altitude" v-model="uploadTelemetryData.current_altitude" @input="handleUploadTelemetryChange" required />
              </div>
              <div>
                  <label>Speed (m/s):</label>
                  <input type="number" step="any" name="speed" v-model="uploadTelemetryData.speed" @input="handleUploadTelemetryChange" />
              </div>
              <div>
                  <label>Battery Level (%):</label>
                  <input type="number" name="battery_level" min="0" max="100" v-model="uploadTelemetryData.battery_level" @input="handleUploadTelemetryChange" required />
              </div>
              <div>
                  <label>Flight Mode:</label>
                  <select name="flight_mode" v-model="uploadTelemetryData.flight_mode" @change="handleUploadTelemetryChange">
                      <option value="manual">Manual</option>
                      <option value="stabilize">Stabilize</option>
                      <option value="althold">AltHold</option>
                      <option value="loiter">Loiter</option>
                      <option value="RTL">RTL</option>
                      <option value="auto">Auto</option>
                      <option value="sport">Sport</option>
                  </select>
              </div>
              <div>
                  <label>Is Flying:</label>
                  <input type="checkbox" name="is_flying" v-model="uploadTelemetryData.is_flying" @change="handleUploadTelemetryChange" />
              </div>
              <button type="submit">Upload Telemetry</button>
          </form>
      </div>
    </section>

    <section class="command-control" style="margin-bottom: 20px; text-align: left; border: 1px solid #ddd; padding: 15px; border-radius: 8px;">
      <h2>Issue Command</h2>
      <form @submit.prevent="handleIssueCommand">
        <div>
          <label>Command Type:</label>
          <select name="command_type" v-model="commandData.command_type" @change="handleCommandChange">
            <option value="hover">Hover</option>
            <option value="takeoff">Takeoff</option>
            <option value="land">Land</option>
            <option value="goto_waypoint">Go to Waypoint</option>
            <option value="arm">Arm</option>
            <option value="disarm">Disarm</option>
          </select>
        </div>
        <template v-if="commandData.command_type === 'goto_waypoint'">
          <div>
            <label>Target Latitude:</label>
            <input type="number" step="any" name="target_latitude" v-model="commandData.target_latitude" @input="handleCommandChange" required />
          </div>
          <div>
            <label>Target Longitude:</label>
            <input type="number" step="any" name="target_longitude" v-model="commandData.target_longitude" @input="handleCommandChange" required />
          </div>
          <div>
            <label>Target Altitude (m):</label>
            <input type="number" step="any" name="target_altitude" v-model="commandData.target_altitude" @input="handleCommandChange" required />
          </div>
        </template>
        <button type="submit">Issue Command</button>
      </form>
    </section>

    <section class="command-history" style="margin-bottom: 20px; text-align: left; border: 1px solid #ddd; padding: 15px; border-radius: 8px;">
      <h2>Command History</h2>
      <div v-if="commands.length === 0">
        <p>No commands issued for this drone yet.</p>
      </div>
      <ul v-else style="list-style-type: none; padding: 0;">
        <li v-for="cmd in commands" :key="cmd.id" style="
          border: 1px solid #eee;
          border-radius: 5px;
          padding: 10px;
          margin-bottom: 5px;
          background-color: #fefefe;
        ">
          <p><strong>ID:</strong> {{ cmd.id }}</p>
          <p><strong>Type:</strong> {{ cmd.command_type }}</p>
          <p v-if="cmd.command_type === 'goto_waypoint'"><strong>Target:</strong> Lat {{ cmd.target_latitude }}, Lon {{ cmd.target_longitude }}, Alt {{ cmd.target_altitude }}m</p>
          <p><strong>Status:</strong> {{ cmd.status }}</p>
          <p><strong>Issued By:</strong> {{ cmd.issued_by }} ({{ cmd.issuer_username || 'N/A' }})</p>
          <p><strong>Issued At:</strong> {{ new Date(cmd.issued_at).toLocaleString() }}</p>
          <div v-if="cmd.status !== 'completed' && cmd.status !== 'failed' && (currentUser?.role === 'admin' || currentUser?.id === cmd.issued_by)">
              <button @click="handleUpdateCommandStatus(cmd.id, 'completed')" style="background-color: #28a745; margin-right: 5px;">Mark as Completed</button>
              <button @click="handleUpdateCommandStatus(cmd.id, 'failed')" style="background-color: #dc3545;">Mark as Failed</button>
          </div>
        </li>
      </ul>
    </section>
  </div>
</template>

<style scoped>
/* ... */
</style>