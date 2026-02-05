<template>
  <div class="repo-viewer" :class="{ 'dark-mode': isDarkMode }">
    <!-- Header Section -->
    <header class="header">
      <div class="logo">
        <svg-icon name="git" width="24" height="24" />
        <h1>{{ appName }}</h1>
      </div>
      
      <div class="actions">
        <button @click="toggleTheme" class="btn-icon">
          {{ isDarkMode ? '☀️' : '🌙' }}
        </button>
        <button @click="refreshData" class="btn-primary" :disabled="loading">
          <span v-if="loading">Syncing...</span>
          <span v-else>Sync Repos</span>
        </button>
      </div>
    </header>

    <!-- Main Content -->
    <main class="content">
      <div v-if="error" class="error-banner">
        {{ error }}
        <span class="close" @click="error = null">&times;</span>
      </div>

      <div class="repo-grid">
        <repo-card 
          v-for="repo in filteredRepos" 
          :key="repo.id"
          :repo="repo"
          @open="handleOpenRepo"
          @delete="handleDeleteRepo"
        />
      </div>

      <div v-if="repos.length === 0 && !loading" class="empty-state">
        <p>No repositories found.</p>
        <button @click="showAddModal = true">Add Your First Repo</button>
      </div>
    </main>

    <!-- Modals -->
    <add-repo-modal 
      v-if="showAddModal" 
      @close="showAddModal = false" 
      @confirm="addRepo" 
    />
  </div>
</template>

<script lang="ts">
import { defineComponent, ref, computed, onMounted } from 'vue';
import RepoCard from './components/RepoCard.vue';
import AddRepoModal from './components/AddRepoModal.vue';
import { useRepoStore } from './stores/repo';

interface Repository {
  id: string;
  name: string;
  url: string;
  stars: number;
}

export default defineComponent({
  name: 'RepoViewer',
  components: {
    RepoCard,
    AddRepoModal
  },
  props: {
    initialTheme: {
      type: String,
      default: 'system'
    }
  },
  setup(props) {
    // Reactive State
    const appName = ref('GitCode Viewer');
    const isDarkMode = ref(false);
    const loading = ref(false);
    const error = ref<string | null>(null);
    const showAddModal = ref(false);
    const searchQuery = ref('');

    const repoStore = useRepoStore();

    // Computed Properties
    const repos = computed(() => repoStore.repositories);
    
    const filteredRepos = computed(() => {
      if (!searchQuery.value) return repos.value;
      return repos.value.filter(r => 
        r.name.toLowerCase().includes(searchQuery.value.toLowerCase())
      );
    });

    // Lifecycle Hooks
    onMounted(async () => {
      console.log('Component Mounted');
      await refreshData();
    });

    // Methods
    const toggleTheme = () => {
      isDarkMode.value = !isDarkMode.value;
      document.body.classList.toggle('dark', isDarkMode.value);
    };

    const refreshData = async () => {
      loading.value = true;
      try {
        await repoStore.fetchRepos();
      } catch (e) {
        error.value = 'Failed to fetch repositories.';
      } finally {
        loading.value = false;
      }
    };

    const handleOpenRepo = (repo: Repository) => {
      console.log('Opening repo:', repo.name);
      // Navigate to detail view
    };

    const handleDeleteRepo = async (id: string) => {
      if (confirm('Are you sure you want to delete this repo?')) {
        await repoStore.deleteRepo(id);
      }
    };

    const addRepo = async (url: string) => {
      try {
        await repoStore.cloneRepo(url);
        showAddModal.value = false;
      } catch (e) {
        error.value = 'Invalid Git URL';
      }
    };

    return {
      appName,
      isDarkMode,
      loading,
      error,
      showAddModal,
      repos,
      filteredRepos,
      toggleTheme,
      refreshData,
      handleOpenRepo,
      handleDeleteRepo,
      addRepo
    };
  }
});
</script>

<style scoped>
/* Variables */
:root {
  --primary: #42b883;
  --bg-light: #ffffff;
  --bg-dark: #1a1a1a;
  --text-light: #2c3e50;
  --text-dark: #e0e0e0;
}

.repo-viewer {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  color: var(--text-light);
  background: var(--bg-light);
  min-height: 100vh;
  transition: all 0.3s ease;
}

.dark-mode {
  color: var(--text-dark);
  background: var(--bg-dark);
}

.header {
  display: flex;
  justify-content: space-between;
  padding: 1rem 2rem;
  border-bottom: 1px solid #ddd;
}

.repo-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 1.5rem;
  padding: 2rem;
}

.btn-primary {
  background-color: var(--primary);
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  cursor: pointer;
}

.btn-primary:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

/* Transitions */
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.5s;
}
.fade-enter, .fade-leave-to {
  opacity: 0;
}
</style>