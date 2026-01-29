// Rust Sample Code - Task Management System
//
// @see https://doc.rust-lang.org/

#[derive(Debug)]
enum Priority { Low, Medium, High, Critical }

#[derive(Debug)]
enum TaskStatus { Pending, InProgress, Review, Completed }

#[derive(Debug)]
struct Task {
    id: u32,
    title: String,
    priority: Priority,
    status: TaskStatus,
}

struct TaskManager {
    tasks: Vec<Task>,
    next_id: u32,
}

impl TaskManager {
    fn new() -> Self {
        Self { tasks: Vec::new(), next_id: 1 }
    }

    fn create(&mut self, title: &str, priority: Priority) -> &Task {
        let task = Task {
            id: self.next_id,
            title: title.to_string(),
            priority,
            status: TaskStatus::Pending,
        };
        self.next_id += 1;
        self.tasks.push(task);
        self.tasks.last().unwrap()
    }

    fn count(&self) -> usize {
        self.tasks.len()
    }
}

fn main() {
    let mut m = TaskManager::new();
    m.create("Implement auth", Priority::High);
    println!("Tasks: {}", m.count());
}
