#!/bin/bash

# Set error handling
set -e

# Configuration
APP_NAME="webapp"
LOG_DIR="/var/log/svelte-app"
BACKUP_DIR="/var/backup/svelte-app"
BUILD_DIR="build"  # or your actual build directory
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
PROJECT_DIR="/path/to/your/project"  # TODO: This needs to be set to your actual project directory

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/build_$TIMESTAMP.log"

# Function for logging
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Function for error handling
handle_error() {
    log "Error occurred in build script at line $1"
    exit 1
}

# Set up error handling
trap 'handle_error $LINENO' ERR

# Ensure we're in the correct directory
if [ ! -d "$PROJECT_DIR" ]; then
    log "Error: Project directory $PROJECT_DIR does not exist"
    exit 1
fi

log "Changing to project directory: $PROJECT_DIR"
cd "$PROJECT_DIR" || exit 1

# Update repository
log "Updating git repository..."
if ! git pull origin main 2>&1 | tee -a "$LOG_FILE"; then
    log "Error: Git pull failed"
    exit 1
fi

# Start build process
log "Starting build process..."

# Install dependencies
log "Installing dependencies..."
pnpm install --frozen-lockfile 2>&1 | tee -a "$LOG_FILE"

# Create backup of current build if it exists
if [ -d "$BUILD_DIR" ]; then
    log "Creating backup of current build..."
    mkdir -p "$BACKUP_DIR"
    cp -r "$BUILD_DIR" "$BACKUP_DIR/build_$TIMESTAMP"
fi

# Build the application
log "Building application..."
NODE_ENV=production NODE_OPTIONS="--max-old-space-size=2048" pnpm run build 2>&1 | tee -a "$LOG_FILE"

# Verify build
if [ ! -d "$BUILD_DIR" ]; then
    log "Build failed - build directory not created"
    exit 1
fi

# Stop existing PM2 process if it exists
log "Checking for existing PM2 process..."
if pm2 list | grep -q "$APP_NAME"; then
    log "Stopping existing PM2 process..."
    pm2 stop "$APP_NAME" 2>&1 | tee -a "$LOG_FILE"
    pm2 delete "$APP_NAME" 2>&1 | tee -a "$LOG_FILE"
fi

# Start with PM2
log "Starting application with PM2..."
pm2 start npm --name "$APP_NAME" -- start 2>&1 | tee -a "$LOG_FILE"

# Save PM2 process list
log "Saving PM2 process list..."
pm2 save 2>&1 | tee -a "$LOG_FILE"

log "Build and deployment completed successfully!"
