#!/bin/bash
# Tuic游戏加速模块

function install_tuic() {
    log "开始安装Tuic..."
    # 下载预编译二进制文件（示例URL，需替换为实际）
    wget https://github.com/EAimTY/tuic/releases/download/0.8.5/tuic-server-0.8.5-x86_64-linux-gnu -O /usr/bin/tuic-server
    chmod +x /usr/bin/tuic-server

    # 创建配置目录
    mkdir -p /etc/tuic

    # 生成配置
    local password=$(openssl rand -base64 12)
    cat > /etc/tuic/config.json <<EOF
{
    "server": "[::]:443",
    "users": {
        "uuid1": "$password"
    },
    "certificate": "/etc/ssl/certs/ssl-cert-snakeoil.pem",
    "private_key": "/etc/ssl/private/ssl-cert-snakeoil.key",
    "congestion_control": "bbr",
    "alpn": ["h3"]
}
EOF

    # 创建系统服务
    cat > /etc/systemd/system/tuic.service <<EOF
[Unit]
Description=Tuic Server
After=network.target

[Service]
ExecStart=/usr/bin/tuic-server -c /etc/tuic/config.json
Restart=always

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable tuic
    systemctl start tuic

    log "Tuic安装完成，密码: $password"
}