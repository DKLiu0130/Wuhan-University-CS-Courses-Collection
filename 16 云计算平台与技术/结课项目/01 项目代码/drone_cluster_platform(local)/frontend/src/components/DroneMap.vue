<script setup>
import 'leaflet/dist/leaflet.css';
import { LMap, LTileLayer, LMarker, LIcon, LTooltip, LPopup } from '@vue-leaflet/vue-leaflet';
import { ref, onMounted, onUnmounted, watch, computed } from 'vue';
import { useAuthStore } from '../stores/auth';
import { useRouter } from 'vue-router';
import { api } from '../api/auth';

// Props definition
const props = defineProps({
  drones: {
    type: Array,
    default: () => []
  },
  selectedDroneId: {
    type: [String, Number, null],
    default: null
  }
});

const emit = defineEmits(['update:selectedDroneId']);

const authStore = useAuthStore();
const router = useRouter();

const zoom = ref(13);
const center = ref([31.2304, 121.4737]); // Default to Shanghai

// Computed property to calculate center based on drones
const mapCenter = computed(() => {
  if (props.drones && props.drones.length > 0) {
    const avgLat = props.drones.reduce((sum, d) => sum + parseFloat(d.current_latitude || 0), 0) / props.drones.length;
    const avgLng = props.drones.reduce((sum, d) => sum + parseFloat(d.current_longitude || 0), 0) / props.drones.length;
    return [avgLat, avgLng];
  }
  return center.value;
});

let fetchInterval = null;

// Get drone icon based on status
const getDroneIcon = (battery_level, is_flying) => {
  let color = 'blue';
  
  if (battery_level !== undefined && battery_level !== null) {
    if (battery_level > 60) {
      color = 'green';
    } else if (battery_level > 30) {
      color = 'yellow';
    } else {
      color = 'red';
    }
  }
  
  // Using emoji or unicode symbols instead of external icons
  const iconHtml = `
    <div style="
      background-color: ${color};
      width: 32px;
      height: 32px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-weight: bold;
      border: 2px solid white;
      box-shadow: 0 2px 4px rgba(0,0,0,0.3);
    ">
      ${is_flying ? '✈' : '📍'}
    </div>
  `;
  
  return L.divIcon({ html: iconHtml, iconSize: [32, 32], className: '' });
};

// Fetch latest telemetry
const fetchLatestTelemetry = async () => {
  try {
    const response = await api.get('/drones/telemetry');
    console.log('Latest telemetry:', response.data);
  } catch (error) {
    console.error('Failed to fetch telemetry:', error);
  }
};

// Select drone on map
const selectDrone = (drone) => {
  emit('update:selectedDroneId', drone.drone_id);
  console.log('Selected drone:', drone.drone_id);
};

onMounted(() => {
  // Fetch telemetry on mount
  fetchLatestTelemetry();
  
  // Optionally fetch telemetry periodically
  // fetchInterval = setInterval(fetchLatestTelemetry, 3000);
});

onUnmounted(() => {
  if (fetchInterval) {
    clearInterval(fetchInterval);
  }
});

// Watch for drones prop changes
watch(() => props.drones, (newDrones) => {
  console.log('Drones updated in map:', newDrones);
}, { deep: true });
</script>

<template>
  <div style="height: 500px; width: 100%; border-radius: 8px; overflow: hidden; position: relative;">
    <l-map 
      v-if="drones && drones.length > 0"
      :zoom="zoom" 
      :center="mapCenter" 
      style="height: 100%; width: 100%;"
    >
      <l-tile-layer
        url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
        layer-type="base"
        name="OpenStreetMap"
        attribution="&copy; OpenStreetMap contributors"
      ></l-tile-layer>
      
      <l-marker
        v-for="drone in drones"
        :key="drone.drone_id"
        :lat-lng="[parseFloat(drone.current_latitude), parseFloat(drone.current_longitude)]"
        @click="selectDrone(drone)"
        :class="{ selected: drone.drone_id === selectedDroneId }"
      >
        <l-icon
          :icon="getDroneIcon(drone.battery_level, drone.is_flying)"
        ></l-icon>
        <l-tooltip>
          <div style="min-width: 200px;">
            <p><strong>无人机 ID:</strong> {{ drone.drone_id }}</p>
            <p><strong>飞行模式:</strong> {{ drone.flight_mode }}</p>
            <p><strong>状态:</strong> {{ drone.is_flying ? '飞行中' : '已降落' }}</p>
            <p v-if="drone.battery_level !== undefined"><strong>电池电量:</strong> {{ drone.battery_level }}%</p>
            <p v-if="drone.speed !== undefined"><strong>速度:</strong> {{ parseFloat(drone.speed).toFixed(1) }} m/s</p>
            <p v-if="drone.current_altitude !== undefined"><strong>高度:</strong> {{ parseFloat(drone.current_altitude).toFixed(1) }} m</p>
            <p><strong>经度:</strong> {{ parseFloat(drone.current_longitude).toFixed(4) }}</p>
            <p><strong>纬度:</strong> {{ parseFloat(drone.current_latitude).toFixed(4) }}</p>
            <p v-if="drone.error_message" style="color: red;"><strong>错误:</strong> {{ drone.error_message }}</p>
            <p v-if="drone.updated_at"><strong>更新时间:</strong> {{ new Date(drone.updated_at).toLocaleTimeString() }}</p>
          </div>
        </l-tooltip>
      </l-marker>
    </l-map>
    
    <div v-else style="
      display: flex;
      align-items: center;
      justify-content: center;
      height: 100%;
      background-color: #f5f5f5;
      color: #999;
    ">
      <p>加载地图中或无可用无人机数据...</p>
    </div>
  </div>
</template>

<style scoped>
.selected {
  border: 2px solid gold;
}
</style>