// Go Sample Code - Task Management System
//
// @see https://go.dev/doc/

package main

import "fmt"

type Priority string

const (
    Low      Priority = "low"
    Medium   Priority = "medium"
    High     Priority = "high"
    Critical Priority = "critical"
)

type TaskStatus string

const (
    Pending    TaskStatus = "pending"
    InProgress TaskStatus = "in_progress"
    Review     TaskStatus = "review"
    Completed  TaskStatus = "completed"
)

type Task struct {
    id       int
    title    string
    priority Priority
    status   TaskStatus
}

type TaskManager struct {
    tasks   map[int]*Task
    nextId  int
}

func New() *TaskManager {
    return &TaskManager{tasks: make(map[int]*Task)}
}

func (m *TaskManager) Create(title string, priority Priority) *Task {
    t := &Task{id: m.nextId, title: title, priority: priority, status: Pending}
    m.nextId++
    m.tasks[t.id] = t
    return t
}

func (m *TaskManager) Count() int {
    return len(m.tasks)
}

func main() {
    m := New()
    m.Create("Implement auth", High)
    fmt.Printf("Tasks: %d\n", m.Count())
}
