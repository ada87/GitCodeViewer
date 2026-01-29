# Task Management Documentation

## Overview

This document describes the task management system.

## Features

- **Create tasks** with priority levels
- **Track status** through workflow states
- **Assign to users** for accountability

## Task States

| State | Description |
|-------|-------------|
| Pending | Task created but not started |
| In Progress | Actively being worked on |
| Review | Awaiting review |
| Completed | Finished and approved |

## Example

```typescript
interface Task {
    id: number;
    title: string;
    priority: 'low' | 'medium' | 'high' | 'critical';
}
```
