/*
 * Dart Sample Code - Task Management System
 *
 * @see https://dart.dev/guides
 */

enum Priority { low, medium, high, critical }

enum TaskStatus { pending, inProgress, review, completed }

class Task {
  final int id;
  String title;
  Priority priority;
  TaskStatus status;

  Task(this.id, this.title, this.priority) : status = TaskStatus.pending;
}

class TaskManager {
  final List<Task> _tasks = [];
  int _nextId = 1;

  Task create(String title, Priority priority) {
    final task = Task(_nextId, title, priority);
    _nextId++;
    _tasks.add(task);
    return task;
  }

  int get count => _tasks.length;
}

void main() {
  final m = TaskManager();
  m.create("Implement auth", Priority.high);
  print("Tasks: ${m.count}");
}
