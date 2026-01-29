<script setup lang="ts">
/**
 * Vue Sample Code - Task Management Component
 *
 * @see https://vuejs.org/guide/
 */

import { ref, computed } from 'vue'

interface Task {
    id: number
    title: string
    priority: string
    status: string
}

const tasks = ref<Task[]>([])
const newTask = ref('')

function addTask() {
    if (newTask.value.trim()) {
        tasks.value.push({
            id: Date.now(),
            title: newTask.value,
            priority: 'medium',
            status: 'pending'
        })
        newTask.value = ''
    }
}

const taskCount = computed(() => tasks.value.length)
</script>

<template>
    <div class="task-manager">
        <h1>Task Manager ({{ taskCount }})</h1>
        <input v-model="newTask" @keyup.enter="addTask" placeholder="New task...">
        <ul>
            <li v-for="task in tasks" :key="task.id">{{ task.title }}</li>
        </ul>
    </div>
</template>
