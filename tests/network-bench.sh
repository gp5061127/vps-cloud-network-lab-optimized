#!/bin/bash
# 网络性能测试

function run_iperf() {
    echo "启动iperf3服务端..."
    iperf3 -s
}

function run_speedtest() {
    echo "运行Speedtest..."
    curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -
}

function test_udp() {
    echo "测试UDP性能..."
    iperf3 -c 1.1.1.1 -u -b 100M -t 10
}

case "$1" in
    iperf) run_iperf ;;
    speedtest) run_speedtest ;;
    udp) test_udp ;;
    *) echo "Usage: $0 [iperf|speedtest|udp]" ;;
esac