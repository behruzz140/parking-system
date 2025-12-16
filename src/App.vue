<script setup lang="ts">
import { ref } from 'vue'
import StatisticsCard from './components/StatisticsCard.vue'
import SearchBar from './components/SearchBar.vue'
import SessionsTable from './components/SessionsTable.vue'
import SessionModal from './components/SessionModal.vue'
import type { ParkingSession } from './lib/supabase'

const statsRef = ref<InstanceType<typeof StatisticsCard>>()
const tableRef = ref<InstanceType<typeof SessionsTable>>()
const selectedSession = ref<ParkingSession | null>(null)
const isModalOpen = ref(false)

const handleSearch = (query: string) => {
  tableRef.value?.handleSearch(query)
}

const handleSessionClick = (session: ParkingSession) => {
  selectedSession.value = session
  isModalOpen.value = true
}

const handleModalClose = () => {
  isModalOpen.value = false
  selectedSession.value = null
}
</script>

<template>
  <div class="app-container">
    <header class="app-header">
      <h1>��️ Avtoturargoh boshqaruvi</h1>
    </header>

    <main class="app-main">
      <StatisticsCard ref="statsRef" />

      <div class="content-section">
        <SearchBar @search="handleSearch" />
        <SessionsTable
          ref="tableRef"
          @session-click="handleSessionClick"
        />
      </div>
    </main>

    <SessionModal
      :session="selectedSession"
      :is-open="isModalOpen"
      @close="handleModalClose"
    />
  </div>
</template>

<style lang="scss">
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
  background: #f5f7fa;
  color: #1a1a1a;
  line-height: 1.6;
}

.app-container {
  min-height: 100vh;
  padding-bottom: 40px;
}

.app-header {
  background: white;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  padding: 24px 32px;
  margin-bottom: 32px;

  h1 {
    font-size: 28px;
    font-weight: 700;
    color: #1a1a1a;
  }
}

.app-main {
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 32px;
}

.content-section {
  background: white;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

@media (max-width: 768px) {
  .app-header {
    padding: 20px 16px;

    h1 {
      font-size: 22px;
    }
  }

  .app-main {
    padding: 0 16px;
  }

  .content-section {
    padding: 16px;
  }
}

@media (prefers-color-scheme: dark) {
  body {
    background: #1a1a1a;
    color: #ffffff;
  }

  .app-header {
    background: #2a2a2a;

    h1 {
      color: #ffffff;
    }
  }

  .content-section {
    background: #2a2a2a;
  }
}
</style>
