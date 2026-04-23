#!/usr/bin/env bash
set -euo pipefail
# Install launchd plist for persistent kubectl port-forwards (macOS)

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLIST_SRC="$REPO_ROOT/scripts/com.example.k8s.portforward.plist"
PLIST_DST="$HOME/Library/LaunchAgents/com.example.k8s.portforward.plist"
LOG_DIR="$REPO_ROOT/logs"

mkdir -p "$LOG_DIR"
mkdir -p "$(dirname "$PLIST_DST")"

tmpfile="$(mktemp /tmp/com.example.k8s.portforward.plist.XXXXXX)"
sed "s|__REPO_PATH__|$REPO_ROOT|g" "$PLIST_SRC" > "$tmpfile"
mv "$tmpfile" "$PLIST_DST"

# Load (unload first to avoid duplicate)
launchctl unload "$PLIST_DST" 2>/dev/null || true
launchctl load "$PLIST_DST"

echo "Installed and loaded: $PLIST_DST"
echo "Logs: $LOG_DIR/portforward-macos.log"
