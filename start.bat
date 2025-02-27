@echo off
REM 检查 Docker 是否已安装
docker --version >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Docker is not installed. Please install Docker and try again.
    pause
    exit /b 1
)

REM 检查 Docker 是否正在运行
docker ps >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Docker is not running. Please start Docker and try again.
    pause
    exit /b 1
)

REM 构建 Docker 镜像
echo Building Docker image...
docker-compose build
if %ERRORLEVEL% neq 0 (
    echo Failed to build Docker image.
    pause
    exit /b 1
)

REM 启动 Docker 容器
echo Starting Docker container...
docker-compose up -d
if %ERRORLEVEL% neq 0 (
    echo Failed to start Docker container.
    pause
    exit /b 1
)

REM 显示成功信息
echo OpenResty proxy is running on http://localhost:8090
echo Press any key to exit...
pause >nul