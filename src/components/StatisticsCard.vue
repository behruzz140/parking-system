<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { supabase } from '../lib/supabase'
import Drawer from 'primevue/drawer'

const stats = ref({
  totalSessions: 0,
  totalPayment: 0,
  totalExits: 0,
  carsInside: 0
})

const drawerVisible = ref(false)

const loadStats = async () => {
  const today = new Date()
  today.setHours(0, 0, 0, 0)

  const { data: sessions } = await supabase
    .from('parking_sessions')
    .select('*')
    .gte('entry_time', today.toISOString())

  if (sessions) {
    stats.value.totalSessions = sessions.length
    stats.value.totalPayment = sessions.reduce((sum, s) => sum + s.amount_paid, 0)
    stats.value.totalExits = sessions.filter(s => s.status === 'exited').length
    stats.value.carsInside = sessions.filter(s => s.status === 'inside').length
  }
}

onMounted(() => {
  loadStats()
})

defineExpose({ loadStats })
</script>

<template>
  <div>
    <h2 class="operator-h2">Operator</h2>




    <div class="statistics">
      <h2>Bugungi statistika</h2>

      <div class="stats-grid">
        <div class="stat-card">
          <div class="stat-icon">📊</div>
          <div class="stat-info">
            <div class="stat-label">Sessiyalar soni</div>
            <div class="stat-value">{{ stats.totalSessions }}</div>
          </div>
        </div>

        <div class="stat-card">
          <div class="stat-icon">💰</div>
          <div class="stat-info">
            <div class="stat-label">Umumiy to'lov</div>
            <div class="stat-value">{{ stats.totalPayment.toLocaleString() }} so'm</div>
          </div>
        </div>

        <div class="stat-card">
          <div class="stat-icon">🚗</div>
          <div class="stat-info">
            <div class="stat-label">Chiqishlar soni</div>
            <div class="stat-value">{{ stats.totalExits }}</div>
          </div>
        </div>

        <div class="stat-card">
          <div class="stat-icon">🅿️</div>
          <div class="stat-info">
            <div class="stat-label">Ichkaridagilar</div>
            <div class="stat-value">{{ stats.carsInside }}</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>


<style scoped lang="scss">
.operator-h2 {
  color: #fff;
}

.statistics {
  margin-bottom: 32px;

  h2 {
    font-size: 24px;
    font-weight: 600;
    margin-bottom: 20px;
    color: #1a1a1a;
  }
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap: 16px;
}

.stat-card {
  background: white;
  border-radius: 12px;
  padding: 24px;
  display: flex;
  align-items: center;
  gap: 16px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  transition: transform 0.2s, box-shadow 0.2s;

  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
  }
}

.stat-icon {
  font-size: 32px;
  width: 56px;
  height: 56px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f5f5f5;
  border-radius: 12px;
}

.stat-info {
  flex: 1;
}

.stat-label {
  font-size: 14px;
  color: #666;
  margin-bottom: 4px;
}

.stat-value {
  font-size: 24px;
  font-weight: 700;
  color: #1a1a1a;
}

@media (prefers-color-scheme: dark) {
  .statistics h2 {
    color: #ffffff;
  }

  .stat-card {
    background: #2a2a2a;
  }

  .stat-icon {
    background: #3a3a3a;
  }

  .stat-label {
    color: #aaa;
  }

  .stat-value {
    color: #ffffff;
  }
}
</style>
