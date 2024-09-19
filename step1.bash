#!/bin/bash

sudo x11vnc -storepasswd /home/$USER/.vnc/passwd

cat <<EOF | sudo tee /etc/systemd/system/x11vnc.service
[Unit]
Description=x11vnc (Remote access)
After=network-online.target

[Service]
Type=simple
ExecStart=/usr/bin/x11vnc -auth guess -display $DISPLAY -rfbauth /home/$(whoami)/.vnc/passwd -rfbport 5900 -forever -loop -xkb -noxdamage -repeat -shared
ExecStop=/bin/kill -TERM \$MAINPID
ExecReload=/bin/kill -HUP \$MAINPID
KillMode=control-group
Restart=on-failure

[Install]
WantedBy=graphical.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable x11vnc.service
sudo systemctl start x11vnc.service

echo '***INSTRUCTION*****************'
echo '* do the following command    *'
echo '* sudo reboot                 *'
echo '*******************************'