#!/usr/bin/env bash
# Persistent kubectl port-forwards (macOS)
# Use with launchd plist (provided) to run at login and keep alive.
set -euo pipefail

while true; do
  echo "$(date) starting port-forwards"
  kubectl port-forward deployment/shoppingapi-deployment 31000:80 &
  p1=$!
  kubectl port-forward deployment/shoppingclient-deployment 30000:80 &
  p2=$!

  wait $p1 $p2
  echo "$(date) a port-forward exited — restarting in 2s"
  sleep 2
done
