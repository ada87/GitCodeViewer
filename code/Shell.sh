#!/bin/bash
#
# Shell Sample Code - Task Management Script
#
# @see https://www.gnu.org/software/bash/manual/

set -euo pipefail

TASKS_FILE="tasks.json"

add_task() {
    local title="$1"
    echo "{\"id\": $(date +%s), \"title\": \"$title\", \"status\": \"pending\"}" >> "$TASKS_FILE"
}

list_tasks() {
    cat "$TASKS_FILE" 2>/dev/null || echo "[]"
}

case "${1:-list}" in
    add)
        add_task "$2"
        ;;
    list)
        list_tasks
        ;;
esac
