<script setup lang="ts">
import { ref } from 'vue'

const searchQuery = ref('')

const emit = defineEmits<{
  search: [query: string]
}>()

const handleSearch = () => {
  emit('search', searchQuery.value)
}
</script>

<template>
  <div class="search-bar">
    <div class="search-input-wrapper">
      <span class="search-icon">🔍</span>
      <input
        v-model="searchQuery"
        type="text"
        placeholder="Davlat raqami bo'yicha qidirish..."
        class="search-input"
        @input="handleSearch"
      />
    </div>
  </div>
</template>

<style scoped lang="scss">
.search-bar {
  margin-bottom: 24px;
}

.search-input-wrapper {
  position: relative;
  max-width: 500px;
}

.search-icon {
  position: absolute;
  left: 16px;
  top: 50%;
  transform: translateY(-50%);
  font-size: 18px;
  pointer-events: none;
}

.search-input {
  width: 100%;
  padding: 14px 16px 14px 48px;
  font-size: 16px;
  border: 2px solid #e0e0e0;
  border-radius: 12px;
  background: white;
  transition: border-color 0.2s, box-shadow 0.2s;

  &:focus {
    outline: none;
    border-color: #4a90e2;
    box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.1);
  }

  &::placeholder {
    color: #999;
  }
}

@media (prefers-color-scheme: dark) {
  .search-input {
    background: #2a2a2a;
    border-color: #444;
    color: #ffffff;

    &:focus {
      border-color: #4a90e2;
    }

    &::placeholder {
      color: #666;
    }
  }
}
</style>
