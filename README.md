# Svelte App Fast - Build Script Documentation

This repository contains a build script (`build-svelte-app-fast.sh`) that automates the build process of Svelte App Fast on Ubuntu 24.04 LTS VPS hosting solutions. It _might_ also work for other svelte applications and Ubuntu versions.

## Getting Started

### Installation

1. Clone the repository:

```bash
git clone https://github.com/realJogicodes/build-svelte-app-fast.git
```

2. Navigate to the repository:

```bash
cd build-svelte-app-fast
```

3. Make the script executable:

```bash
chmod +x build-svelte-app-fast.sh
```

## Build Script Overview

The `build-svelte-app-fast.sh` is an automation script that handles the build process with robust error handling and logging capabilities.

### Key Features

- **Automated Build Process**: Handles the complete build pipeline from code update to deployment
- **Error Handling**: Includes robust error detection and logging
- **Backup System**: Automatically creates backups of previous builds
- **Process Management**: Manages PM2 processes for zero-downtime deployments
- **Logging**: Detailed logging of all operations with timestamps

### Process Flow

1. **Initial Setup**

   - Creates necessary log directories
   - Validates project directory existence
   - Sets up error handling traps

2. **Repository Update**

   - Pulls latest code from the main branch
   - Validates git operations

3. **Build Process**

   - Installs dependencies using pnpm with frozen lockfile
   - Creates backup of existing build
   - Builds the application with production settings
   - Verifies build output

4. **Deployment**
   - Manages PM2 processes (stops existing instance if any)
   - Starts the application using PM2
   - Saves PM2 process list for persistence

### Configuration

The script uses several configurable variables:

- `APP_NAME`: Name of the your application in PM2
- `LOG_DIR`: Directory for build logs (`/var/log/svelte-app`)
- `BACKUP_DIR`: Directory for build backups (`/var/backup/svelte-app`)
- `BUILD_DIR`: Build output directory
- `PROJECT_DIR`: Root project directory

### Logging

All operations are logged with timestamps in two locations:

- Console output during execution
- Log files in the specified log directory (`/var/log/svelte-app`)

### Prerequisites

- Node.js and pnpm installed
- PM2 process manager
- Git
- Appropriate permissions for log and backup directories

## Usage

To run the build script:

```bash
./build-svelte-app-fast.sh
```

The script will handle the entire build and deployment process automatically, with detailed logging of each step.

## Error Handling

The script includes comprehensive error handling:

- Validates directory existence
- Checks for successful git operations
- Verifies build output
- Handles PM2 process management errors

All errors are logged with timestamps and line numbers for debugging purposes.
