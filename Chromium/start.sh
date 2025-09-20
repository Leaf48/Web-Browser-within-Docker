#!/usr/bin/env bash
set -e

export DISPLAY=${DISPLAY:-:99}
export SCREEN=${SCREEN:-1920x1080x24}
export CHROMIUM_LANG=${CHROMIUM_LANG:-ja}

echo "Starting Xvfb on display ${DISPLAY} with screen ${SCREEN}"

# Virtual display
Xvfb ${DISPLAY} -screen 0 ${SCREEN} -ac -extension GLX -extension RANDR -extension RENDER &
XVFB_PID=$!

# wait until Xvfb starts
echo "Waiting for Xvfb to start..."
for i in $(seq 1 30); do
    if xdpyinfo -display ${DISPLAY} > /dev/null 2>&1; then
        echo "Xvfb is ready"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "Timeout waiting for Xvfb to start"
        exit 1
    fi
    sleep 1
done

# Window manager
echo "Starting fluxbox..."
fluxbox &

sleep 2

# VNC
echo "Starting x11vnc..."
x11vnc -display ${DISPLAY} -nopw -forever -shared -rfbport 5900 -bg -xkb

sleep 2

# noVNC to be accessed on a browser
echo "Starting noVNC websockify..."
websockify --web=/usr/share/novnc/ 6080 localhost:5900 &

sleep 2

# Chromium
echo "Starting Chromium..."
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
  --user-data-dir=/tmp/chrome-profile \
  --disable-background-timer-throttling \
  --disable-renderer-backgrounding \
  --disable-backgrounding-occluded-windows \
  --remote-debugging-port=9223 \
  --disable-web-security \
  --disable-features=VizDisplayCompositor \
"

# <RECV with 9222 port> <FORWARD-TO 9223 port>
socat -d -d TCP-LISTEN:9222,bind=0.0.0.0,fork,reuseaddr TCP:127.0.0.1:9223 &

# run chromium in the background
chromium $CHROMIUM_FLAGS about:blank &

echo "All services started. Waiting for processes..."

# wait all background process
wait
