#!/bin/bash
# Gost隧道模块

function install_gost() {
    log "开始安装Gost..."
    wget https://github.com/ginuerzh/gost/releases/download/v2.11.5/gost-linux-amd64-2.11.5.gz
    gunzip gost-linux-amd64-2.11.5.gz
    mv gost-linux-amd64-2.11.5 /usr/bin/gost
    chmod +x /usr/bin/gost

    # 创建系统服务
    cat > /etc/systemd/system/gost.service <<EOF
[Unit]
Description=GO Simple Tunnel
After=network.target

[Service]
ExecStart=/usr/bin/gost -L=relay+tls://:443?secure=true -F=forward://target_ip:port
Restart=always

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable gost
    systemctl start gost

    log "Gost安装完成"
}