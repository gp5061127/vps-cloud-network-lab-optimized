#!/bin/bash
# 网络优化配置

function apply_network_optimizations() {
    log "应用网络优化参数..."
    
    # 启用BBR
    if ! sysctl net.ipv4.tcp_congestion_control | grep -q bbr; then
        echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
        echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
        sysctl -p
    fi
    
    # 优化TCP参数
    sysctl -w net.ipv4.tcp_fastopen=3
    sysctl -w net.ipv4.tcp_syn_retries=3
    sysctl -w net.ipv4.tcp_fin_timeout=30
    sysctl -w net.ipv4.tcp_keepalive_time=1200
    
    log "网络优化完成"
}
