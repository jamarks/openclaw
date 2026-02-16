#!/bin/bash
set -e

echo "Entrypoint script starting..."
echo "Current user: $(whoami) (UID: $(id -u))"

# Fix volume permissions if running as root and /data exists
if [ "$(id -u)" = "0" ]; then
    echo "Running as root, fixing permissions..."
    if [ -d "/data" ]; then
        echo "Found /data directory, setting ownership to node:node..."
        chown -R node:node /data 2>/dev/null || echo "Warning: Could not chown /data"
        mkdir -p /data/.openclaw /data/workspace 2>/dev/null || echo "Warning: Could not create directories"
        chown -R node:node /data/.openclaw /data/workspace 2>/dev/null || echo "Warning: Could not chown subdirectories"
        ls -la /data || true
    fi

    echo "Switching to node user and executing: $@"
    # Switch to node user and execute the command
    exec gosu node "$@"
else
    # Already running as node user
    echo "Already running as node user, executing: $@"
    exec "$@"
fi
