#!/bin/bash
# WARP模块

function install_warp() {
    log "开始安装Cloudflare WARP..."
    curl https://pkg.cloudflareclient.com/pubkey.gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflare-client.list
    apt-get update
    apt-get install -y cloudflare-warp

    # 注册和配置
    warp-cli register
    warp-cli set-mode proxy
    warp-cli connect
    warp-cli enable-always-on

    log "Cloudflare WARP安装完成"
}