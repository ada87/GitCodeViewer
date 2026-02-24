#!/usr/bin/env python3
"""FastAPI-style web application with async support."""

from __future__ import annotations

import asyncio
from dataclasses import dataclass, field
from datetime import datetime
from enum import Enum
from typing import Optional
from uuid import uuid4


class TaskStatus(Enum):
    PENDING = "pending"
    RUNNING = "running"
    COMPLETED = "completed"
    FAILED = "failed"


@dataclass
class Task:
    id: str = field(default_factory=lambda: str(uuid4()))
    title: str = ""
    description: str = ""
    status: TaskStatus = TaskStatus.PENDING
    priority: int = 0
    tags: list[str] = field(default_factory=list)
    created_at: datetime = field(default_factory=datetime.now)
    completed_at: Optional[datetime] = None

    def complete(self) -> None:
        self.status = TaskStatus.COMPLETED
        self.completed_at = datetime.now()

    def fail(self, reason: str) -> None:
        self.status = TaskStatus.FAILED
        self.description += f"\nFailed: {reason}"


class TaskQueue:
    """Async task queue with priority scheduling."""

    def __init__(self, max_concurrent: int = 5):
        self._queue: asyncio.PriorityQueue[tuple[int, Task]] = asyncio.PriorityQueue()
        self._semaphore = asyncio.Semaphore(max_concurrent)
        self._results: dict[str, Task] = {}

    async def submit(self, task: Task) -> str:
        await self._queue.put((-task.priority, task))
        return task.id

    async def process_next(self) -> Optional[Task]:
        async with self._semaphore:
            if self._queue.empty():
                return None
            _, task = await self._queue.get()
            task.status = TaskStatus.RUNNING
            try:
                await self._execute(task)
                task.complete()
            except Exception as e:
                task.fail(str(e))
            self._results[task.id] = task
            return task

    async def _execute(self, task: Task) -> None:
        # Simulate work
        await asyncio.sleep(0.1)

    def get_result(self, task_id: str) -> Optional[Task]:
        return self._results.get(task_id)

    @property
    def pending_count(self) -> int:
        return self._queue.qsize()


async def main():
    queue = TaskQueue(max_concurrent=3)

    tasks = [
        Task(title="Build project", priority=10, tags=["ci"]),
        Task(title="Run tests", priority=8, tags=["ci", "test"]),
        Task(title="Deploy staging", priority=5, tags=["deploy"]),
        Task(title="Send notifications", priority=1, tags=["notify"]),
    ]

    for task in tasks:
        await queue.submit(task)

    print(f"Queued {queue.pending_count} tasks")

    while queue.pending_count > 0:
        result = await queue.process_next()
        if result:
            print(f"[{result.status.value}] {result.title}")


if __name__ == "__main__":
    asyncio.run(main())
