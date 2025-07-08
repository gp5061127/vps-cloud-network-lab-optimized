#!/bin/bash
# 网络诊断工具

function test_latency() {
    echo "测试到 Cloudflare DNS 的延迟..."
    ping -c 10 1.1.1.1 | tail -n2
}

function test_throughput() {
    echo "测试网络吞吐量 (使用 iperf3)..."
    echo "请先在另一台服务器运行: iperf3 -s"
    read -p "输入服务器IP: " server_ip
    iperf3 -c "$server_ip" -J | jq '.end.sum_received.bits_per_second'
}

function check_qos() {
    echo "检测QoS限制..."
    local results=()
    for port in 80 443 8080; do
        echo "测试端口 $port ..."
        result=$(nc -zv -w 2 1.1.1.1 $port 2>&1)
        results+=("$port: $result")
    done
    
    printf '%s\n' "${results[@]}"
}

function fix_firewall() {
    echo "配置防火墙规则..."
    # 确保必要的端口开放
    ufw allow 22/tcp
    ufw allow 80/tcp
    ufw allow 443/tcp
    ufw allow 443/udp
    ufw --force enable
    echo "防火墙规则已更新"
}

# 主菜单
case "$1" in
    --test)
        case "$2" in
            latency) test_latency ;;
            throughput) test_throughput ;;
            qos) check_qos ;;
            *) echo "未知测试类型" ;;
        esac
        ;;
    --fix)
        case "$2" in
            firewall) fix_firewall ;;
            *) echo "未知修复目标" ;;
        esac
        ;;
    *)
        echo "使用方法:"
        echo "  $0 --test [latency|throughput|qos]"
        echo "  $0 --fix [firewall]"
        ;;
esac
