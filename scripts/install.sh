#!/bin/bash
# 智能安装向导

# 加载核心库
source core/loader.sh

# 主安装函数
function main() {
    # 解析参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            --wizard)
                run_wizard
                ;;
            --preset)
                preset=$2
                shift
                load_preset "$preset"
                ;;
            *)
                echo "Unknown option: $1"
                exit 1
                ;;
        esac
        shift
    done
    
    # 默认安装流程
    if [[ -z "$preset" ]]; then
        run_wizard
    fi
}

# 交互式向导
function run_wizard() {
    echo "=== VPS Network Lab Installation Wizard ==="
    
    # 选择使用场景
    PS3="请选择使用场景: "
    options=("科学上网" "游戏加速" "企业VPN" "网络实验")
    select opt in "${options[@]}"
    do
        case $opt in
            "科学上网")
                load_preset "proxy"
                break
                ;;
            "游戏加速")
                load_preset "gaming"
                break
                ;;
            "企业VPN")
                load_preset "enterprise"
                break
                ;;
            "网络实验")
                setup_network_lab
                break
                ;;
            *) echo "无效选项 $REPLY";;
        esac
    done
}

# 加载预设配置
function load_preset() {
    local preset=$1
    local preset_file="../conf/presets/$preset.json"
    
    if [[ ! -f "$preset_file" ]]; then
        error "Preset $preset not found!"
        exit 1
    fi
    
    log "Loading preset: $preset"
    
    # 解析预设配置
    local protocols=$(jq -r '.protocols[]' "$preset_file")
    for proto in $protocols; do
        load_module "$proto"
        install_$proto
    done
    
    # 应用网络优化
    source core/network-opt.sh
    apply_network_optimizations
}

main "$@"