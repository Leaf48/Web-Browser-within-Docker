FROM debian:12-slim

ENV DEBIAN_FRONTEND=noninteractive \
    DISPLAY=:99 \
    SCREEN=1920x1080x24 \
    LANG=ja_JP.UTF-8 \
    LC_ALL=ja_JP.UTF-8 \
    TZ=Asia/Tokyo \
    CHROMIUM_LANG=ja

#  X/VNC / Chromium
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates wget gnupg locales tzdata \
    xvfb x11vnc fluxbox novnc websockify \
    fonts-noto-cjk \
    chromium \
    libxss1 libgbm1 libxshmfence1 libcups2 libatk-bridge2.0-0 libatspi2.0-0 \
 && sed -i 's/# \(ja_JP.UTF-8\)/\1/' /etc/locale.gen && locale-gen \
 && rm -rf /var/lib/apt/lists/*

# script
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 5900 6080 9222
CMD ["/start.sh"]
