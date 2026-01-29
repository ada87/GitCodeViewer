/*
 * Kotlin Sample Code - Task Management System
 *
 * @see https://kotlinlang.org/docs/home.html
 */

enum class Priority(val value: String) {
    LOW("low"),
    MEDIUM("medium"),
    HIGH("high"),
    CRITICAL("critical")
}

enum class TaskStatus(val value: String) {
    PENDING("pending"),
    IN_PROGRESS("in_progress"),
    REVIEW("review"),
    COMPLETED("completed")
}

data class Task(
    val id: Int,
    val title: String,
    val priority: Priority,
    var status: TaskStatus = TaskStatus.PENDING
)

class TaskManager {
    private val tasks = mutableListOf<Task>()
    private var nextId = 1

    fun create(title: String, priority: Priority): Task {
        val task = Task(nextId++, title, priority)
        tasks.add(task)
        return task
    }

    fun count(): Int = tasks.size
}

fun main() {
    val m = TaskManager()
    m.create("Implement auth", Priority.HIGH)
    println("Tasks: ${m.count()}")
}
