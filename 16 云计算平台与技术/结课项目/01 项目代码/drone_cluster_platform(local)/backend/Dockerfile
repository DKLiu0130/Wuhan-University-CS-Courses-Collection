# backend/Dockerfile

# 使用官方的 Python 镜像作为基础镜像
FROM python:3.9-slim-buster

ARG HTTP_PROXY
ARG HTTPS_PROXY
ARG NO_PROXY

ENV HTTP_PROXY=${HTTP_PROXY}
ENV HTTPS_PROXY=${HTTPS_PROXY}
ENV NO_PROXY=${NO_PROXY}

# 设置工作目录
WORKDIR /app

# 将 requirements.txt 复制到工作目录中
COPY requirements.txt .

# 修改 apt 源列表以使用归档镜像 (保持用户原有设置)
RUN rm -f /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian buster main contrib non-free" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security buster/updates main contrib non-free" >> /etc/apt/sources.list && \
    # 更新 apt 缓存并安装 curl 以及构建 psycopg2-binary 可能需要的 libpq-dev
    apt-get update && apt-get install -y --no-install-recommends \
    curl \
    libpq-dev \  
    gcc \        
    && rm -rf /var/lib/apt/lists/*

# 安装 Python 依赖
# --no-cache-dir 节省空间
# --compile 启用编译，但通常 pip 会自动做
RUN pip install --no-cache-dir -r requirements.txt

# 将所有应用代码复制到工作目录中
COPY . .

# 暴露 Flask 应用运行的端口
EXPOSE 5000

# 定义环境变量，Flask 会自动发现
ENV FLASK_APP=app.py
# FLASK_ENV 和 DEBUG 将从 docker-compose.yml 通过 .env 注入，所以这里不需要硬编码
# ENV FLASK_ENV=development
# ENV FLASK_DEBUG=True

# CMD 使用 Gunicorn 运行应用
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]