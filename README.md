# X-UI 进程监控服务

## 项目介绍

这是一个用于监控和自动维护 x-ui 面板服务的工具。当 x-ui 进程意外停止时，监控服务会自动检测并重启 x-ui 服务，确保您的 x-ui 面板始终保持运行状态。

## 功能特点

- 定期检查 x-ui 进程状态（默认每2分钟检查一次）
- 自动重启已停止的 x-ui 服务
- 详细的日志记录，包括检查时间和重启结果
- 自动清理过期日志（默认保留1天）
- 作为系统服务运行，开机自启动

## 文件说明

本项目包含两个主要文件：

1. `x-ui-monitor.sh` - 监控脚本，负责检查和重启 x-ui 服务
2. `x-ui-monitor.service` - systemd 服务配置文件，用于将监控脚本注册为系统服务

## 安装前提

- 已安装 x-ui 面板
- 使用 systemd 的 Linux 系统（如 Debian、Ubuntu 等）
- 具有 root 或 sudo 权限

## 安装步骤

1. 下载项目文件

```bash
# 创建临时目录并进入
mkdir -p /tmp/x-ui-monitor && cd /tmp/x-ui-monitor

# 下载项目文件（假设您已将文件上传到某个位置，或者使用 git clone）
# 这里需要替换为实际的下载命令
```

2. 安装监控脚本

```bash
# 复制监控脚本到系统目录
sudo cp x-ui-monitor.sh /usr/local/bin/

# 设置执行权限
sudo chmod +x /usr/local/bin/x-ui-monitor.sh
```

3. 安装系统服务

```bash
# 复制服务文件到 systemd 目录
sudo cp x-ui-monitor.service /etc/systemd/system/

# 重新加载 systemd 配置
sudo systemctl daemon-reload

# 启用服务（开机自启）
sudo systemctl enable x-ui-monitor.service

# 启动服务
sudo systemctl start x-ui-monitor.service
```

## 服务管理

### 查看服务状态

```bash
sudo systemctl status x-ui-monitor.service
```

### 启动服务

```bash
sudo systemctl start x-ui-monitor.service
```

### 停止服务

```bash
sudo systemctl stop x-ui-monitor.service
```

### 重启服务

```bash
sudo systemctl restart x-ui-monitor.service
```

### 禁用服务（取消开机自启）

```bash
sudo systemctl disable x-ui-monitor.service
```

## 查看日志

监控服务的日志保存在 `/var/log/x-ui-monitor.log`，您可以使用以下命令查看：

```bash
sudo cat /var/log/x-ui-monitor.log
```

或者实时查看日志：

```bash
sudo tail -f /var/log/x-ui-monitor.log
```

## 自定义配置

如果您需要修改检查间隔或日志保留时间，请编辑 `/usr/local/bin/x-ui-monitor.sh` 文件：

- 修改检查间隔：更改脚本末尾的 `sleep 120` 值（单位：秒）
- 修改日志保留时间：更改 `find "$LOG_FILE" -mtime +1 -delete` 中的 `+1` 值（单位：天）

修改后需要重启服务以应用更改：

```bash
sudo systemctl restart x-ui-monitor.service
```

## 卸载

如果您需要卸载监控服务，请执行以下步骤：

```bash
# 停止并禁用服务
sudo systemctl stop x-ui-monitor.service
sudo systemctl disable x-ui-monitor.service

# 删除服务文件
sudo rm /etc/systemd/system/x-ui-monitor.service

# 删除监控脚本
sudo rm /usr/local/bin/x-ui-monitor.sh

# 删除日志文件（可选）
sudo rm /var/log/x-ui-monitor.log

# 重新加载 systemd 配置
sudo systemctl daemon-reload
```