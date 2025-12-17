<script setup lang="ts">
import { type ParkingSession } from '../lib/supabase'

defineProps<{
  session: ParkingSession | null
  isOpen: boolean
}>()

const emit = defineEmits<{
  close: []
}>()

const formatDate = (dateString: string | null) => {
  if (!dateString) return 'N/A'
  const date = new Date(dateString)
  return date.toLocaleString('ru-RU', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  })
}

const handlePrint = () => {
  window.print()
}

const handleClose = () => {
  emit('close')
}
</script>

<template>
  <Transition name="modal">
    <div v-if="isOpen && session" class="modal-overlay" @click="handleClose">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h2>Информация о сессии</h2>
          <button class="close-btn" @click="handleClose">✕</button>
        </div>

        <div class="modal-body">
          <div class="info-row">
            <div class="info-label">Номер машины:</div>
            <div class="info-value license">{{ session.license_plate }}</div>
          </div>

          <div class="info-row">
            <div class="info-label">Время входа:</div>
            <div class="info-value">{{ formatDate(session.entry_time) }}</div>
          </div>

          <div class="info-row">
            <div class="info-label">Время выхода:</div>
            <div class="info-value">
              {{ session.exit_time ? formatDate(session.exit_time) : 'Еще в парковке' }}
            </div>
          </div>

          <div class="info-row">
            <div class="info-label">Оплачено:</div>
            <div class="info-value amount">{{ session.amount_paid.toLocaleString() }} сум</div>
          </div>

          <div class="info-row">
            <div class="info-label">Статус:</div>
            <div class="info-value">
              <span :class="['status-badge', session.status]">
                {{ session.status === 'inside' ? 'Ichkarida' : 'Chiqdi' }}
              </span>
            </div>
          </div>
        </div>

        <div class="modal-footer">
          <button class="btn btn-print" @click="handlePrint">
            🖨️ Напечатать чек
          </button>
          <button class="btn btn-close" @click="handleClose">
            Закрыть
          </button>
        </div>
      </div>
    </div>
  </Transition>
</template>

<style scoped lang="scss">
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.6);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  backdrop-filter: blur(4px);
}

.modal-content {
  background: white;
  border-radius: 16px;
  width: 90%;
  max-width: 500px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  overflow: hidden;
}

.modal-header {
  padding: 24px;
  border-bottom: 2px solid #f0f0f0;
  display: flex;
  align-items: center;
  justify-content: space-between;

  h2 {
    font-size: 20px;
    font-weight: 600;
    color: #1a1a1a;
    margin: 0;
  }

  .close-btn {
    display: flex;
    align-items: center;
    justify-content: center;
    // width: 32px;
    // height: 32px;
    border: none;
    background: #f5f5f5;
    border-radius: 8px;
    font-size: 20px;
    cursor: pointer;
    transition: background-color 0.2s;

    &:hover {
      background: #e0e0e0;
    }
  }
}

.modal-body {
  padding: 24px;
}

.info-row {
  display: flex;
  justify-content: space-between;
  padding: 12px 0;
  border-bottom: 1px solid #f0f0f0;

  &:last-child {
    border-bottom: none;
  }
}

.info-label {
  font-size: 14px;
  color: #666;
  font-weight: 500;
}

.info-value {
  font-size: 14px;
  color: #1a1a1a;
  font-weight: 600;

  &.license {
    color: #4a90e2;
    font-size: 16px;
  }

  &.amount {
    color: #2e7d32;
    font-size: 16px;
  }
}

.status-badge {
  display: inline-block;
  padding: 4px 12px;
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

.modal-footer {
  padding: 20px 24px;
  background: #f8f9fa;
  display: flex;
  gap: 12px;
  justify-content: flex-end;
}

.btn {
  padding: 12px 24px;
  border: none;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;

  &.btn-print {
    background: #4a90e2;
    color: white;

    &:hover {
      background: #357abd;
      transform: translateY(-1px);
    }
  }

  &.btn-close {
    background: white;
    color: #666;
    border: 1px solid #e0e0e0;

    &:hover {
      background: #f5f5f5;
    }
  }
}

.modal-enter-active,
.modal-leave-active {
  transition: opacity 0.3s;

  .modal-content {
    transition: transform 0.3s;
  }
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;

  .modal-content {
    transform: scale(0.9);
  }
}

@media (prefers-color-scheme: dark) {
  .modal-content {
    background: #2a2a2a;
  }

  .modal-header {
    border-bottom-color: #444;

    h2 {
      color: #ffffff;
    }

    .close-btn {
      background: #3a3a3a;
      color: #ffffff;

      &:hover {
        background: #4a4a4a;
      }
    }
  }

  .info-row {
    border-bottom-color: #444;
  }

  .info-label {
    color: #aaa;
  }

  .info-value {
    color: #ffffff;

    &.license {
      color: #4a90e2;
    }

    &.amount {
      color: #66bb6a;
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

  .modal-footer {
    background: #333;
  }

  .btn {
    &.btn-close {
      background: #3a3a3a;
      color: #ddd;
      border-color: #555;

      &:hover {
        background: #4a4a4a;
      }
    }
  }
}
</style>
