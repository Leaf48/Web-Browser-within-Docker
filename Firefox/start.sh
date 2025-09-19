#!/usr/bin/env bash
set -e

Xvfb ${DISPLAY} -screen 0 ${SCREEN} &
fluxbox &

x11vnc -display ${DISPLAY} -nopw -forever -shared -rfbport 5900 &

websockify --web=/usr/share/novnc/ 6080 localhost:5900 &

exec firefox about:blank

