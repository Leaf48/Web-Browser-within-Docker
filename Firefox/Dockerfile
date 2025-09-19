FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    DISPLAY=:99 \
    SCREEN=1920x1080x24 \
    FIREFOX_LANG=ja 

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates wget xz-utils \
    xvfb x11vnc fluxbox novnc websockify bzip2 \
    fonts-noto-cjk \
    libgtk-3-0 libglib2.0-0 libnss3 libnspr4 libx11-xcb1 libxt6 libxrandr2 \
    libxcomposite1 libxdamage1 libxfixes3 libxrender1 libasound2 libpulse0 && \
    rm -rf /var/lib/apt/lists/*


# Mozilla; install either x86_64 / ARM64 based on the architecture
RUN arch=$(dpkg --print-architecture); \
    if [ "$arch" = "arm64" ]; then FF_OS="linux64-aarch64"; else FF_OS="linux64"; fi; \
    wget -nv --content-disposition -P /tmp \
      "https://download.mozilla.org/?product=firefox-latest&os=${FF_OS}&lang=${FIREFOX_LANG}" \
 && FF=$(ls /tmp/firefox-*.tar.* | head -n1) \
 && tar -xaf "$FF" -C /opt \ 
 && ln -sf /opt/firefox/firefox /usr/bin/firefox \
 && rm -f "$FF"


COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 5900 6080 9222
CMD ["/start.sh"]

