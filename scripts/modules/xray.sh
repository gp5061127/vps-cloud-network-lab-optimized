#!/bin/bash
# Xray核心模块

function install_xray() {
    log "开始安装Xray..."
    bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
    
    # 生成基础配置
    mkdir -p /usr/local/etc/xray
    cat > /usr/local/etc/xray/config.json <<XRAY_CFG
{
    "inbounds": [
        {
            "port": 443,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "uuid"
                    }
                ]
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ]
}
XRAY_CFG
    
    # 重启服务
    systemctl restart xray
    
    log "Xray安装完成"
}
