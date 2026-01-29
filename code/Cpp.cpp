/*
 * C++ Sample Code - Task Management System
 *
 * @see https://en.cppreference.com/w/cpp
 */

#include <iostream>
#include <string>
#include <map>
#include <set>

enum class Priority { Low, Medium, High, Critical };
enum class TaskStatus { Pending, InProgress, Review, Completed };

class Task {
public:
    int id;
    std::string title;
    Priority priority;
    TaskStatus status;

    Task(int i, std::string t, Priority p) : id(i), title(std::move(t)), priority(p), status(TaskStatus::Pending) {}
};

class TaskManager {
    std::map<int, Task> tasks;
    int nextId = 1;

public:
    Task* create(const std::string& title, Priority p) {
        auto* t = new Task(nextId++, title, p);
        tasks[t->id] = *t;
        return t;
    }

    size_t count() const { return tasks.size(); }
};

int main() {
    TaskManager m;
    m.create("Implement auth", Priority::High);
    std::cout << "Tasks: " << m.count() << std::endl;
    return 0;
}
