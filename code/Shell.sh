#!/bin/bash

# ==============================================================================
# GitCode Viewer - Repository Maintenance Script
# This script automates backup, cleaning, and update checks for local repos.
# ==============================================================================

# --- Configuration ---
APP_NAME="GitCodeViewer"
REPO_DIR="$HOME/code-viewer/repos"
BACKUP_DIR="$HOME/code-viewer/backups"
MAX_BACKUPS=5
DATE_STAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="/tmp/codeviewer_maintenance.log"

# --- Colors for Output ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# --- Functions ---

log() {
    local level=$1
    local msg=$2
    echo -e "[$(date +'%T')] ${level}: ${msg}" | tee -a "$LOG_FILE"
}

check_dependencies() {
    log "${BLUE}INFO${NC}" "Checking system dependencies..."
    
    if ! command -v git &> /dev/null; then
        log "${RED}ERROR${NC}" "Git is not installed. Please install git."
        exit 1
    fi

    if ! command -v tar &> /dev/null; then
        log "${RED}ERROR${NC}" "Tar is not installed."
        exit 1
    fi
    
    log "${GREEN}OK${NC}" "All dependencies met."
}

create_backup() {
    log "${BLUE}INFO${NC}" "Starting backup of $REPO_DIR..."
    
    if [ ! -d "$REPO_DIR" ]; then
        log "${YELLOW}WARN${NC}" "Repository directory not found. Nothing to backup."
        return
    fi

    mkdir -p "$BACKUP_DIR"
    
    local backup_file="$BACKUP_DIR/repos_backup_$DATE_STAMP.tar.gz"
    
    tar -czf "$backup_file" -C "$(dirname "$REPO_DIR")" "$(basename "$REPO_DIR")"
    
    if [ $? -eq 0 ]; then
        log "${GREEN}SUCCESS${NC}" "Backup created at $backup_file"
        
        # Calculate size
        local size=$(du -h "$backup_file" | cut -f1)
        log "${BLUE}INFO${NC}" "Backup size: $size"
    else
        log "${RED}ERROR${NC}" "Backup failed!"
        exit 1
    fi
}

cleanup_old_backups() {
    log "${BLUE}INFO${NC}" "Cleaning up old backups (keeping last $MAX_BACKUPS)..."
    
    # Find backups, sort by time, skip top N, and delete the rest
    ls -tp "$BACKUP_DIR"/repos_backup_*.tar.gz | grep -v '/$' | tail -n +$((MAX_BACKUPS + 1)) | xargs -I {} rm -- {}
    
    log "${GREEN}SUCCESS${NC}" "Cleanup complete."
}

sync_repos() {
    log "${BLUE}INFO${NC}" "Syncing repositories..."
    
    find "$REPO_DIR" -maxdepth 1 -type d | while read -r repo; do
        if [ -d "$repo/.git" ]; then
            repo_name=$(basename "$repo")
            echo -n "  Syncing $repo_name... "
            
            # Go into dir, pull, and capture output
            cd "$repo"
            git fetch origin > /dev/null 2>&1
            
            # Check if behind
            local behind=$(git rev-list --count HEAD..origin/HEAD 2>/dev/null)
            
            if [ "$behind" -gt 0 ]; then
                 echo -e "${YELLOW}Updates available ($behind commits)${NC}"
            else
                 echo -e "${GREEN}Up to date${NC}"
            fi
            cd - > /dev/null
        fi
    done
}

show_stats() {
    echo ""
    echo "----------------------------------------"
    echo "       System Statistics"
    echo "----------------------------------------"
    echo "Disk Usage: "
    df -h "$REPO_DIR" | tail -n 1 | awk '{print $5 " used on " $6}'
    echo "Total Repos: $(find "$REPO_DIR" -maxdepth 1 -type d | wc -l)"
    echo "Uptime: $(uptime -p)"
    echo "----------------------------------------"
}

# --- Main Execution ---

echo "=========================================="
echo "   $APP_NAME Maintenance Tool"
echo "=========================================="

check_dependencies

# User prompt
read -p "Do you want to run backup? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    create_backup
    cleanup_old_backups
else
    log "${YELLOW}SKIP${NC}" "Skipping backup."
fi

sync_repos

show_stats

log "${GREEN}DONE${NC}" "Maintenance script finished successfully."
exit 0