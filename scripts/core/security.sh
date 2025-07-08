#!/bin/bash
# 安全加固模块

function apply_security() {
    local level=$1
    local enable_fail2ban=$2
    local enable_autoupdate=$3

    log "应用安全加固 (级别: $level)"

    # 基础加固
    if [[ "$level" == "medium" || "$level" == "high" ]]; then
        # 禁用root SSH登录
        sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
        systemctl restart sshd

        # 设置防火墙
        ufw default deny incoming
        ufw default allow outgoing
        ufw allow 22/tcp
        ufw allow 80/tcp
        ufw allow 443/tcp
        ufw allow 443/udp
        ufw --force enable
    fi

    # 高级加固
    if [[ "$level" == "high" ]]; then
        # 设置入侵检测
        apt-get install -y aide
        aideinit
        mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db
        echo "0 0 * * * /usr/bin/aide --check" | crontab -
    fi

    # 安装fail2ban
    if [[ "$enable_fail2ban" == "true" ]]; then
        apt-get install -y fail2ban
        systemctl enable fail2ban
        systemctl start fail2ban
    fi

    # 启用自动更新
    if [[ "$enable_autoupdate" == "true" ]]; then
        apt-get install -y unattended-upgrades
        dpkg-reconfigure -plow unattended-upgrades
    fi

    log "安全加固完成"
}