<?php
/**
 * PHP Sample Code - Task Management System
 *
 * @see https://www.php.net/manual/en/
 */

enum Priority: string {
    case Low = 'low';
    case Medium = 'medium';
    case High = 'high';
    case Critical = 'critical';
}

enum TaskStatus: string {
    case Pending = 'pending';
    case InProgress = 'in_progress';
    case Review = 'review';
    case Completed = 'completed';
}

class Task {
    public function __construct(
        public int $id,
        public string $title,
        public Priority $priority,
        public TaskStatus $status = TaskStatus::Pending
    ) {}
}

class TaskManager {
    private array $tasks = [];
    private int $nextId = 1;

    public function create(string $title, Priority $priority): Task {
        $task = new Task($this->nextId++, $title, $priority);
        $this->tasks[$task->id] = $task;
        return $task;
    }

    public function count(): int {
        return count($this->tasks);
    }
}

$m = new TaskManager();
$m->create("Implement auth", Priority::High);
echo "Tasks: " . $m->count() . "\n";
