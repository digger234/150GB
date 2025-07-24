FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    novnc \
    websockify \
    dbus-x11 \
    && apt-get clean

WORKDIR /app

COPY <<'EOF' /app/start.sh
#!/bin/bash

export USER=root
export HOME=/root
VNC_PASSWORD="yourpassword"

mkdir -p /root/.vnc
echo "$VNC_PASSWORD" | vncpasswd -f > /root/.vnc/passwd
chmod 600 /root/.vnc/passwd

cat <<'EOT' > /root/.vnc/xstartup
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
dbus-launch startxfce4 &
EOT

chmod +x /root/.vnc/xstartup

vncserver :1 -geometry 1280x720 -depth 24

sleep 2

websockify --web /usr/share/novnc/ 8080 localhost:5901
EOF

RUN chmod +x /app/start.sh

EXPOSE 8080

CMD ["/app/start.sh"]
