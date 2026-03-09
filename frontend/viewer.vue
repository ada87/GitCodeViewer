<script setup lang="ts">
import { ref, computed, watch, onMounted } from 'vue'

interface FileItem {
  id: string
  name: string
  language: string
  size: number
  modified: Date
}

const props = defineProps<{
  files: FileItem[]
  initialFilter?: string
}>()

const emit = defineEmits<{
  select: [file: FileItem]
  delete: [id: string]
}>()

const searchQuery = ref(props.initialFilter ?? '')
const selectedId = ref<string | null>(null)
const sortKey = ref<keyof FileItem>('name')
const sortAsc = ref(true)

const filteredFiles = computed(() => {
  const q = searchQuery.value.toLowerCase()
  const filtered = props.files.filter(f =>
    f.name.toLowerCase().includes(q) || f.language.toLowerCase().includes(q)
  )
  return filtered.sort((a, b) => {
    const va = String(a[sortKey.value])
    const vb = String(b[sortKey.value])
    return sortAsc.value ? va.localeCompare(vb) : vb.localeCompare(va)
  })
})

const totalSize = computed(() =>
  filteredFiles.value.reduce((sum, f) => sum + f.size, 0)
)

watch(searchQuery, (val) => {
  if (val && filteredFiles.value.length === 1) {
    selectedId.value = filteredFiles.value[0].id
  }
})

onMounted(() => {
  console.log('FileExplorer mounted with ', props.files.length, ' files')
})

function handleSelect(file: FileItem) {
  selectedId.value = file.id
  emit('select', file)
}

function toggleSort(key: keyof FileItem) {
  if (sortKey.value === key) {
    sortAsc.value = !sortAsc.value
  } else {
    sortKey.value = key
    sortAsc.value = true
  }
}

function formatSize(bytes: number): string {
  if (bytes < 1024) return bytes + ' B'
  if (bytes < 1048576) return (bytes / 1024).toFixed(1) + ' KB'
  return (bytes / 1048576).toFixed(1) + ' MB'
}
</script>

<template>
  <div class="file-explorer">
    <div class="toolbar">
      <input
        v-model="searchQuery"
        type="search"
        placeholder="Filter files..."
        class="search-input"
        aria-label="Filter files"
      />
      <span class="file-count">{{ filteredFiles.length }} files ({{ formatSize(totalSize) }})</span>
    </div>

    <table class="file-table">
      <thead>
        <tr>
          <th @click="toggleSort('name')" class="sortable">Name</th>
          <th @click="toggleSort('language')" class="sortable">Language</th>
          <th @click="toggleSort('size')" class="sortable">Size</th>
        </tr>
      </thead>
      <tbody>
        <tr
          v-for="file in filteredFiles"
          :key="file.id"
          :class="{ selected: file.id === selectedId }"
          @click="handleSelect(file)"
        >
          <td>{{ file.name }}</td>
          <td><span class="lang-badge">{{ file.language }}</span></td>
          <td>{{ formatSize(file.size) }}</td>
        </tr>
        <tr v-if="filteredFiles.length === 0">
          <td colspan="3" class="empty-state">No files match your filter.</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<style scoped>
.file-explorer {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
  font-family: system-ui, sans-serif;
}
.toolbar {
  display: flex;
  align-items: center;
  gap: 1rem;
}
.search-input {
  flex: 1;
  padding: 0.5rem 0.75rem;
  border: 1px solid var(--color-border, #ddd);
  border-radius: 0.375rem;
}
.file-table {
  width: 100%;
  border-collapse: collapse;
}
.file-table th, .file-table td {
  padding: 0.5rem 0.75rem;
  text-align: left;
  border-bottom: 1px solid var(--color-border, #eee);
}
.sortable { cursor: pointer; user-select: none; }
.selected { background: var(--color-primary-light, #e8f0fe); }
.lang-badge {
  display: inline-block;
  padding: 0.125rem 0.5rem;
  border-radius: 1rem;
  background: var(--color-surface-alt, #f0f0f0);
  font-size: 0.8rem;
}
.empty-state { text-align: center; color: var(--color-text-muted, #999); padding: 2rem; }
</style>