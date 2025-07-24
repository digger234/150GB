FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    novnc \
    websockify \
    && apt-get clean

WORKDIR /app

COPY <<'EOF' /app/start.sh
#!/bin/bash

VNC_PASSWORD="123456"

mkdir -p ~/.vnc
echo "$VNC_PASSWORD" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

vncserver :1 -geometry 1280x720 -depth 24

websockify --web /usr/share/novnc/ 8080 localhost:5901
EOF

RUN chmod +x /app/start.sh

EXPOSE 8080

CMD ["/app/start.sh"]
