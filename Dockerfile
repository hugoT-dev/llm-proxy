# 使用 OpenResty 官方镜像
FROM openresty/openresty:latest

# 安装 SSL 证书和其他依赖
RUN apt-get update && apt-get install -y \
    luarocks \
    lua5.1 \
    lua5.1-dev \
    libreadline-dev \
    libssl-dev \
    gcc \
    make \
    ca-certificates

RUN luarocks install lua-resty-http

# 创建配置目录和日志目录
RUN mkdir -p /etc/nginx/lua && \
    mkdir -p /var/log/nginx && \
    chown -R www-data:www-data /var/log/nginx

# 复制 Nginx 配置文件
COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

# 复制配置文件
COPY lua/config.lua /etc/nginx/lua/config.lua

# 复制 Lua 脚本
COPY lua/dynamic_routing.lua /etc/nginx/lua/dynamic_routing.lua

# 暴露端口
EXPOSE 8090

# 启动 OpenResty
CMD ["openresty", "-g", "daemon off;"]