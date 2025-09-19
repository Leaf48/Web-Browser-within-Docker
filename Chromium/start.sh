#!/usr/bin/env bash
set -e

# Virtual display
Xvfb ${DISPLAY} -screen 0 ${SCREEN} &
fluxbox &

# VNC
x11vnc -display ${DISPLAY} -nopw -forever -shared -rfbport 5900 &

# noVNC to be accessed on a browser
websockify --web=/usr/share/novnc/ 6080 localhost:5900 &

# Chromium
CHROMIUM_FLAGS="\
  --no-sandbox \
  --disable-dev-shm-usage \
  --disable-gpu \
  --lang=${CHROMIUM_LANG} \
  --disable-blink-features=AutomationControlled \
  --start-maximized \
  --password-store=basic \
  --no-first-run \
  --remote-allow-origins=* \
  --force-color-profile=srgb \
"

exec chromium --remote-debugging-port=9222 --remote-debugging-address=0.0.0.0 $CHROMIUM_FLAGS about:blank 
