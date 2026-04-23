#!/usr/bin/env bash
set -euo pipefail
# Install systemd user service for persistent kubectl port-forwards (Linux)

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SERVICE_SRC="$REPO_ROOT/scripts/systemd-user-k8s-portforward.service"
SERVICE_DST="$HOME/.config/systemd/user/k8s-portforward.service"
LOG_DIR="$REPO_ROOT/logs"

mkdir -p "$LOG_DIR"
mkdir -p "$(dirname "$SERVICE_DST")"

sed "s|__REPO_PATH__|$REPO_ROOT|g" "$SERVICE_SRC" > "$SERVICE_DST"

systemctl --user daemon-reload
systemctl --user enable --now k8s-portforward.service

echo "Installed and started user service: $SERVICE_DST"
echo "Logs: $LOG_DIR"
