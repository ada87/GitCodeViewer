/*
 * C Sample Code - Task Management System
 *
 * @see https://en.cppreference.com/w/c
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

typedef enum { LOW, MEDIUM, HIGH, CRITICAL } Priority;
typedef enum { PENDING, IN_PROGRESS, REVIEW, COMPLETED } TaskStatus;

typedef struct {
    int id;
    char title[256];
    Priority priority;
    TaskStatus status;
} Task;

typedef struct {
    Task tasks[100];
    int count;
} TaskManager;

void init(TaskManager* m) { m->count = 0; }

Task* create(TaskManager* m, const char* title, Priority p) {
    Task* t = &m->tasks[m->count++];
    t->id = m->count;
    strncpy(t->title, title, 255);
    t->priority = p;
    t->status = PENDING;
    return t;
}

int main() {
    TaskManager m;
    init(&m);
    create(&m, "Implement auth", HIGH);
    printf("Tasks: %d\n", m.count);
    return 0;
}
