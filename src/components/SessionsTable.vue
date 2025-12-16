<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { supabase, type ParkingSession } from '../lib/supabase'

const sessions = ref<ParkingSession[]>([])
const searchQuery = ref('')

const emit = defineEmits<{
  sessionClick: [session: ParkingSession]
}>()

const loadSessions = async () => {
  const { data } = await supabase
    .from('parking_sessions')
    .select('*')
    .order('entry_time', { ascending: false })

  if (data) {
    sessions.value = data
  }
}

const filteredSessions = computed(() => {
  if (!searchQuery.value) return sessions.value

  return sessions.value.filter(session =>
    session.license_plate.toLowerCase().includes(searchQuery.value.toLowerCase())
  )
})

const formatDateTime = (dateString: string) => {
  const date = new Date(dateString)
  return date.toLocaleString('ru-RU', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  })
}

const handleSearch = (query: string) => {
  searchQuery.value = query
}

const handleRowClick = (session: ParkingSession) => {
  emit('sessionClick', session)
}

onMounted(() => {
  loadSessions()
})

defineExpose({ loadSessions, handleSearch })
</script>

<template>
  <div class="sessions-table">
    <h2>Avtoturargoh sessiyalari</h2>
    <div class="table-wrapper">
      <table>
        <thead>
          <tr>
            <th>№</th>
            <th>Davlat raqami</th>
            <th>Boshlanish vaqti</th>
            <th>Holati</th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="(session, index) in filteredSessions"
            :key="session.id"
            @click="handleRowClick(session)"
            class="clickable-row"
          >
            <td>{{ index + 1 }}</td>
            <td class="license-plate">{{ session.license_plate }}</td>
            <td>{{ formatDateTime(session.entry_time) }}</td>
            <td>
              <span :class="['status-badge', session.status]">
                {{ session.status === 'inside' ? 'Ichkarida' : 'Chiqdi' }}
              </span>
            </td>
          </tr>
          <tr v-if="filteredSessions.length === 0">
            <td colspan="4" class="no-data">Ma'lumot topilmadi</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<style scoped lang="scss">
.sessions-table {
  h2 {
    font-size: 20px;
    font-weight: 600;
    margin-bottom: 16px;
    color: #1a1a1a;
  }
}

.table-wrapper {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

table {
  width: 100%;
  border-collapse: collapse;

  thead {
    background: #f8f9fa;

    th {
      padding: 16px;
      text-align: left;
      font-size: 14px;
      font-weight: 600;
      color: #666;
      border-bottom: 2px solid #e0e0e0;
    }
  }

  tbody {
    tr {
      border-bottom: 1px solid #f0f0f0;
      transition: background-color 0.2s;

      &.clickable-row {
        cursor: pointer;

        &:hover {
          background: #f8f9fa;
        }
      }

      &:last-child {
        border-bottom: none;
      }

      td {
        padding: 16px;
        font-size: 14px;
        color: #333;

        &.license-plate {
          font-weight: 600;
          color: #4a90e2;
        }

        &.no-data {
          text-align: center;
          padding: 32px;
          color: #999;
        }
      }
    }
  }
}

.status-badge {
  display: inline-block;
  padding: 6px 12px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 600;

  &.inside {
    background: #e3f2fd;
    color: #1976d2;
  }

  &.exited {
    background: #f1f8e9;
    color: #689f38;
  }
}

@media (prefers-color-scheme: dark) {
  .sessions-table h2 {
    color: #ffffff;
  }

  .table-wrapper {
    background: #2a2a2a;
  }

  table {
    thead {
      background: #333;

      th {
        color: #aaa;
        border-bottom-color: #444;
      }
    }

    tbody tr {
      border-bottom-color: #333;

      &.clickable-row:hover {
        background: #333;
      }

      td {
        color: #ddd;

        &.license-plate {
          color: #4a90e2;
        }

        &.no-data {
          color: #666;
        }
      }
    }
  }

  .status-badge {
    &.inside {
      background: #1a3a52;
      color: #64b5f6;
    }

    &.exited {
      background: #2d3a1f;
      color: #aed581;
    }
  }
}
</style>
