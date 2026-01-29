/**
 * TypeScript Sample Code - Task Management System
 *
 * @see https://www.typescriptlang.org/
 */

namespace TaskManager {
    export type Priority = 'low' | 'medium' | 'high' | 'critical';
    export type TaskStatus = 'pending' | 'in_progress' | 'review' | 'completed';

    export interface Task {
        id: number;
        title: string;
        description: string;
        priority: Priority;
        status: TaskStatus;
        assignee?: string;
        createdAt: Date;
        tags: Set<string>;
    }

    export class TaskManager {
        private tasks = new Map<number, Task>();
        private nextId = 1;

        createTask(task: Task): Task {
            task.id = this.nextId++;
            this.tasks.set(task.id, task);
            return task;
        }

        getAllTasks(): Task[] {
            return Array.from(this.tasks.values());
        }
    }
}

const manager = new TaskManager.TaskManager();
console.log("TypeScript Task Manager initialized");
