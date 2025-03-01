#!/bin/bash

# 日志文件路径
LOG_FILE="/var/log/x-ui-monitor.log"

# 确保日志文件存在
touch "$LOG_FILE"

# 日志清理函数
clean_logs() {
    # 删除超过1天的日志
    find "$LOG_FILE" -mtime +1 -delete
    # 如果日志文件被删除，重新创建
    touch "$LOG_FILE"
}

# 检查x-ui进程状态并记录日志的函数
check_x_ui() {
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    if ! systemctl is-active x-ui &>/dev/null; then
        echo "[$timestamp] x-ui服务未运行，正在重启服务..." >> "$LOG_FILE"
        systemctl restart x-ui
        sleep 5
        if systemctl is-active x-ui &>/dev/null; then
            echo "[$timestamp] x-ui服务重启成功" >> "$LOG_FILE"
        else
            echo "[$timestamp] x-ui服务重启失败" >> "$LOG_FILE"
        fi
    else
        echo "[$timestamp] x-ui进程正在运行" >> "$LOG_FILE"
    fi
}

# 主循环
while true; do
    check_x_ui
    clean_logs
    sleep 120  # 每120秒（2分钟）检查一次
done