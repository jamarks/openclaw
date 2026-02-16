#!/bin/bash
set -e

# Fix volume permissions if running as root and /data exists
if [ "$(id -u)" = "0" ] && [ -d "/data" ]; then
    echo "Fixing volume permissions..."
    chown -R node:node /data || true
    mkdir -p /data/.openclaw /data/workspace || true
    chown -R node:node /data/.openclaw /data/workspace || true

    # Switch to node user and execute the command
    exec su-exec node "$@"
else
    # Already running as node user or /data doesn't exist
    exec "$@"
fi
