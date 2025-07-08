#!/bin/bash
# 模块化加载框架

MODULE_DIR="$(dirname $0)/../modules"

function load_module() {
    local module_name=$1
    local module_file="${MODULE_DIR}/${module_name}.sh"
    
    if [[ -f "$module_file" ]]; then
        source "$module_file"
        log "Module loaded: $module_name"
    else
        error "Module $module_name not found!"
        exit 1
    fi
}

# 日志函数
function log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

function error() {
    echo "[ERROR] $1" >&2
}