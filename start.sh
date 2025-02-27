#!/bin/bash

# 构建 Docker 镜像
docker-compose build

# 启动服务
docker-compose up -d

echo "OpenResty proxy is running on http://localhost:8090"