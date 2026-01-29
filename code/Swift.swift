/*
 * Swift Sample Code - Task Management System
 *
 * @see https://developer.apple.com/swift/
 */

import Foundation

enum Priority: String {
    case low, medium, high, critical
}

enum TaskStatus: String {
    case pending, inProgress, review, completed
}

struct Task {
    let id: Int
    var title: String
    var priority: Priority
    var status: TaskStatus
}

class TaskManager {
    private var tasks: [Task] = []
    private var nextId = 1

    func create(title: String, priority: Priority) -> Task {
        let task = Task(id: nextId, title: title, priority: priority, status: .pending)
        nextId += 1
        tasks.append(task)
        return task
    }

    var count: Int { tasks.count }
}

let m = TaskManager()
m.create(title: "Implement auth", priority: .high)
print("Tasks: \(m.count)")
