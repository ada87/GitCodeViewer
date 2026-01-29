/**
 * Java Sample Code - Task Management System
 *
 * A comprehensive example demonstrating Java OOP design
 * including generics, streams, Optional, and records.
 *
 * @see https://docs.oracle.com/javase/
 * @version 17+
 */

import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Function;
import java.util.stream.Collectors;

public final class TaskManager {
    public enum Priority {
        LOW("low"), MEDIUM("medium"), HIGH("high"), CRITICAL("critical");

        private final String value;
        Priority(String value) { this.value = value; }
        public String getValue() { return value; }
    }

    public enum TaskStatus {
        PENDING("pending"), IN_PROGRESS("in_progress"),
        REVIEW("review"), COMPLETED("completed"), CANCELLED("cancelled");

        private final String value;
        TaskStatus(String value) { this.value = value; }
        public String getValue() { return value; }
    }

    public static class Task {
        private final int id;
        private String title;
        private String description;
        private final Priority priority;
        private TaskStatus status;
        private String assignee;
        private final LocalDateTime createdAt;
        private final Set<String> tags;

        public Task(int id, String title, String description, Priority priority) {
            this.id = id;
            this.title = title;
            this.description = description;
            this.priority = priority;
            this.status = TaskStatus.PENDING;
            this.createdAt = LocalDateTime.now();
            this.tags = new HashSet<>();
        }

        // Getters
        public int getId() { return id; }
        public String getTitle() { return title; }
        public String getDescription() { return description; }
        public Priority getPriority() { return priority; }
        public TaskStatus getStatus() { return status; }
        public String getAssignee() { return assignee; }
        public LocalDateTime getCreatedAt() { return createdAt; }
        public Set<String> getTags() { return Collections.unmodifiableSet(tags); }

        public void setStatus(TaskStatus status) { this.status = status; }
        public void setAssignee(String assignee) { this.assignee = assignee; }
        public void addTag(String tag) { this.tags.add(tag); }

        public boolean hasTag(String tag) { return tags.contains(tag); }

        @Override
        public String toString() {
            return String.format("Task#%d: %s [%s]", id, title, status.getValue());
        }
    }

    public static class TaskManagerImpl {
        private final Map<Integer, Task> tasks = new ConcurrentHashMap<>();
        private int nextId = 1;

        public Task createTask(String title, String description, Priority priority) {
            Task task = new Task(nextId++, title, description, priority);
            tasks.put(task.getId(), task);
            return task;
        }

        public boolean updateTask(int id, Function<Task, Void> updater) {
            Task task = tasks.get(id);
            if (task == null) return false;
            updater.apply(task);
            return true;
        }

        public boolean deleteTask(int id) {
            return tasks.remove(id) != null;
        }

        public List<Task> getAllTasks() {
            return Collections.unmodifiableList(new ArrayList<>(tasks.values()));
        }

        public List<Task> filterTasks(Priority priority, TaskStatus status) {
            return tasks.values().stream()
                    .filter(t -> priority == null || t.getPriority() == priority)
                    .filter(t -> status == null || t.getStatus() == status)
                    .collect(Collectors.toList());
        }

        public Map<String, Integer> getStatistics() {
            Map<String, Integer> stats = new LinkedHashMap<>();
            stats.put("total", tasks.size());
            return stats;
        }
    }

    public static void main(String[] args) {
        TaskManagerImpl manager = new TaskManagerImpl();

        Task task1 = manager.createTask(
                "Implement user authentication",
                "Add JWT-based authentication system",
                Priority.HIGH
        );

        manager.updateTask(task1.getId(), t -> {
            t.setStatus(TaskStatus.IN_PROGRESS);
            t.setAssignee("Alice");
            return null;
        });

        System.out.println("Tasks created: " + manager.getAllTasks().size());
    }
}
