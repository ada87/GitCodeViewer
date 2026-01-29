/**
 * Python Sample Code - Task Management System
 *
 * A comprehensive example demonstrating modern Python features
 * including dataclasses, type hints, decorators, and async/await.
 *
 * @see https://docs.python.org/3/
 * @version 1.0.0
 */

from dataclasses import dataclass, field
from typing import Dict, List, Optional, Set, Callable
from enum import Enum
from datetime import datetime
from functools import wraps
import json


class Priority(Enum):
    """Task priority levels"""
    LOW = "low"
    MEDIUM = "medium"
    HIGH = "high"
    CRITICAL = "critical"


class TaskStatus(Enum):
    """Task status values"""
    PENDING = "pending"
    IN_PROGRESS = "in_progress"
    REVIEW = "review"
    COMPLETED = "completed"
    CANCELLED = "cancelled"


@dataclass
class Task:
    """Represents a single task in the system"""
    id: int
    title: str
    description: str
    priority: Priority = Priority.MEDIUM
    status: TaskStatus = TaskStatus.PENDING
    assignee: Optional[str] = None
    created_at: datetime = field(default_factory=datetime.now)
    due_date: Optional[datetime] = None
    tags: Set[str] = field(default_factory=set)

    def __str__(self) -> str:
        return f"Task(id={self.id}, title='{self.title}', status={self.status.value})"

    def to_dict(self) -> Dict:
        return {
            "id": self.id,
            "title": self.title,
            "description": self.description,
            "priority": self.priority.value,
            "status": self.status.value,
            "assignee": self.assignee,
            "created_at": self.created_at.isoformat(),
            "tags": list(self.tags)
        }


class TaskManager:
    """Manages a collection of tasks with CRUD operations"""

    def __init__(self, name: str = "Default") -> None:
        self._tasks: Dict[int, Task] = {}
        self._id_counter: int = 1
        self._name = name
        self._observers: List[Callable[[Task, str], None]] = []

    def subscribe(self, observer: Callable[[Task, str], None]) -> None:
        """Subscribe to task change events"""
        self._observers.append(observer)

    def _notify(self, task: Task, action: str) -> None:
        """Notify all observers of a task change"""
        for observer in self._observers:
            observer(task, action)

    def create_task(
        self,
        title: str,
        description: str,
        priority: Priority = Priority.MEDIUM,
    ) -> Task:
        """Create a new task and add it to the manager"""
        task = Task(
            id=self._id_counter,
            title=title,
            description=description,
            priority=priority,
        )
        self._tasks[task.id] = task
        self._id_counter += 1
        self._notify(task, "created")
        return task

    def update_task(self, task_id: int, **kwargs) -> Optional[Task]:
        """Update an existing task"""
        task = self._tasks.get(task_id)
        if task is None:
            return None
        for key, value in kwargs.items():
            if hasattr(task, key):
                setattr(task, key, value)
        self._notify(task, "updated")
        return task

    def delete_task(self, task_id: int) -> bool:
        """Delete a task by its ID"""
        if task_id in self._tasks:
            del self._tasks[task_id]
            return True
        return False

    def get_all_tasks(self) -> List[Task]:
        """Get all tasks as a list"""
        return list(self._tasks.values())

    def filter_tasks(
        self,
        priority: Optional[Priority] = None,
        status: Optional[TaskStatus] = None,
    ) -> List[Task]:
        """Filter tasks based on criteria"""
        result = self.get_all_tasks()
        if priority is not None:
            result = [t for t in result if t.priority == priority]
        if status is not None:
            result = [t for t in result if t.status == status]
        return result

    def get_statistics(self) -> Dict:
        """Get task statistics"""
        by_status: Dict[str, int] = {}
        by_priority: Dict[str, int] = {}

        for task in self._tasks.values():
            by_status[task.status.value] = by_status.get(task.status.value, 0) + 1
            by_priority[task.priority.value] = by_priority.get(task.priority.value, 0) + 1

        return {
            "total": len(self._tasks),
            "by_status": by_status,
            "by_priority": by_priority,
        }


def main() -> None:
    """Main entry point"""
    manager = TaskManager("Python Demo")

    task1 = manager.create_task(
        title="Implement user authentication",
        description="Add JWT-based authentication system",
        priority=Priority.HIGH,
    )

    manager.update_task(task1.id, status=TaskStatus.IN_PROGRESS)

    stats = manager.get_statistics()
    print(f"Total tasks: {stats['total']}")


if __name__ == "__main__":
    main()
