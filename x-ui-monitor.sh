#!/bin/bash

# 日志文件路径
LOG_FILE="/var/log/x-ui-monitor.log"

# 确保日志文件存在
touch "$LOG_FILE"

# 日志清理函数
clean_logs() {
    # 只保留当天的日志
    if [ -f "$LOG_FILE" ]; then
        # 创建临时文件
        TEMP_FILE=$(mktemp)
        # 获取当天日期（格式：YYYY-MM-DD）
        TODAY=$(date +%Y-%m-%d)
        
        # 只保留当天的日志行
        grep -a "\[$TODAY" "$LOG_FILE" > "$TEMP_FILE" 2>/dev/null
        
        # 如果有内容被清理，记录清理信息
        if ! cmp -s "$LOG_FILE" "$TEMP_FILE"; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') 已清理非当天的日志记录" >> "$TEMP_FILE"
            cat "$TEMP_FILE" > "$LOG_FILE"
        fi
        
        # 删除临时文件
        rm -f "$TEMP_FILE"
    fi
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
