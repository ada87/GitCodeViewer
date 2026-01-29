/**
 * JavaScript Sample Code - Task Management System
 *
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript
 */

const Priority = Object.freeze({
    LOW: 'low',
    MEDIUM: 'medium',
    HIGH: 'high',
    CRITICAL: 'critical'
});

const TaskStatus = Object.freeze({
    PENDING: 'pending',
    IN_PROGRESS: 'in_progress',
    REVIEW: 'review',
    COMPLETED: 'completed'
});

class Task {
    constructor(id, title, priority) {
        this.id = id;
        this.title = title;
        this.priority = priority;
        this.status = TaskStatus.PENDING;
    }
}

class TaskManager {
    constructor() {
        this.tasks = new Map();
        this.nextId = 1;
    }

    create(title, priority) {
        const task = new Task(this.nextId++, title, priority);
        this.tasks.set(task.id, task);
        return task;
    }

    get count() {
        return this.tasks.size;
    }
}

const m = new TaskManager();
m.create("Implement auth", Priority.HIGH);
console.log(`Tasks: ${m.count}`);
